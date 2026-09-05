// Harvest Horse Boost
// Boosts the Mist Horse's Harvest Horse skill, with an on-foot fallback.

#macro HARVEST_HORSE_BOOST_CONFIG_VERSION 1
#macro HARVEST_HORSE_BOOST_SETTLE_FRAMES 12
#macro HARVEST_HORSE_BOOST_SCAN_INTERVAL 3
#macro HARVEST_HORSE_BOOST_TILE_PIXELS 32

function __harvest_horse_boost_runtime() {
    if (global[$ "__harvest_horse_boost"] == undefined) {
        global.__harvest_horse_boost = {
            registered: false,
            cfg: undefined,
            observed_mounted: undefined,
            active_mounted: undefined,
            stable_frames: 0,
            last_x: undefined,
            last_y: undefined,
            scan_frame: 0,
            dug_this_scan: false,
        };
    }
    return global.__harvest_horse_boost;
}

function harvest_horse_boost_config() {
    var _rt = __harvest_horse_boost_runtime();
    if (_rt.cfg != undefined) return _rt.cfg;

    var _source = mmapi_config_read_valid("harvest_horse_boost", HARVEST_HORSE_BOOST_CONFIG_VERSION);
    _rt.cfg = {
        foot_radius_tiles: mmapi_config_number(_source, "foot_radius_tiles", 1, 0, 4),
        mounted_radius_tiles: mmapi_config_number(_source, "mounted_radius_tiles", 2, 0, 4),
        harvest_fruit_bushes: mmapi_config_bool(_source, "harvest_fruit_bushes", true),
        harvest_fruit_trees: mmapi_config_bool(_source, "harvest_fruit_trees", true),
        mounted_auto_shovel: mmapi_config_bool(_source, "mounted_auto_shovel", true),
        auto_dismount_indoors: mmapi_config_bool(_source, "auto_dismount_indoors", true),
        debug_notifications: mmapi_config_bool(_source, "debug_notifications", true),
    };
    mmapi_config_write("harvest_horse_boost", HARVEST_HORSE_BOOST_CONFIG_VERSION, _rt.cfg);
    return _rt.cfg;
}

function harvest_horse_boost_notify_mode(_mounted, _cfg) {
    if (!_cfg.debug_notifications) return;
    if (_mounted) {
        create_notification("mods/harvest_horse_boost/notifications/mounted");
    } else {
        create_notification("mods/harvest_horse_boost/notifications/on_foot");
    }
}

function harvest_horse_boost_is_target(_node, _cfg) {
    var _category = object_id_to_object_category(_node.object_id);
    if (_category == ObjectCategory.Crop) return true;

    var _proto = _node.prototype;
    if (_proto == undefined) return false;

    if (_category == ObjectCategory.Bush && _cfg.harvest_fruit_bushes) {
        // The generic decorative bush declares "__none__"; only bushes with a
        // real harvest item are eligible.
        var _bush_harvest = _proto[$ "harvest"];
        return _bush_harvest != undefined && _bush_harvest != "__none__";
    }

    if (_category == ObjectCategory.Tree && _cfg.harvest_fruit_trees) {
        // Trees can always be interacted with to shake them, so can_interact()
        // alone is not a harvest test. has_fruit is the game's own flag for
        // currently visible/collectible fruit.
        var _fruit_data = _proto[$ "fruit_data"];
        return _fruit_data != undefined
            && _fruit_data[$ "harvest"] != undefined
            && _node.has_fruit == true;
    }

    return false;
}

function harvest_horse_boost_scan(_radius_tiles) {
    var _radius_pixels = (_radius_tiles * HARVEST_HORSE_BOOST_TILE_PIXELS) + (HARVEST_HORSE_BOOST_TILE_PIXELS / 2);
    var _player_x = obj_ari.x;
    var _player_y = obj_ari.y;

    // Trees additionally require node.has_fruit in is_target(), because the
    // game's can_interact(node) intentionally permits shaking empty trees.
    // can_interact(node) prevents non-ripe crops and bushes from receiving a
    // harvest attempt.
    // interact(node) then preserves the game's drops, perks, and regrowth.
    with (obj_node_renderer) {
        var _node = self.node;
        if (_node != undefined
            && harvest_horse_boost_is_target(_node, __harvest_horse_boost_runtime().cfg)
            && abs(self.x - _player_x) <= _radius_pixels
            && abs(self.y - _player_y) <= _radius_pixels
            && can_interact(_node))
        {
            interact(_node);
        }
    }
}

function harvest_horse_boost_held_shovel() {
    var _held_item = ARI.held_item();
    return _held_item != undefined
        && _held_item.prototype != undefined
        && _held_item.prototype.tool_type == ToolType.Shovel
        ? _held_item
        : undefined;
}

function harvest_horse_boost_scan_dig_sites(_radius_tiles) {
    var _shovel = harvest_horse_boost_held_shovel();
    if (_shovel == undefined) return;

    var _rt = __harvest_horse_boost_runtime();
    _rt.dug_this_scan = false;

    var _radius_pixels = (_radius_tiles * HARVEST_HORSE_BOOST_TILE_PIXELS) + (HARVEST_HORSE_BOOST_TILE_PIXELS / 2);
    var _player_x = obj_ari.x;
    var _player_y = obj_ari.y;

    with (obj_node_renderer) {
        var _node = self.node;
        if (!_rt.dug_this_scan
            && _node != undefined
            && object_id_to_object_category(_node.object_id) == ObjectCategory.DigSite
            && abs(self.x - _player_x) <= _radius_pixels
            && abs(self.y - _player_y) <= _radius_pixels)
        {
            var _cell_x = self.x div 8;
            var _cell_y = self.y div 8;
            if (dig_site_attempt_dig(_cell_x, _cell_y, ARCHAEOLOGY.choose_random_artifact())) {
                create_animation_effect(
                    _cell_x * 8 + 8,
                    _cell_y * 8 + 8,
                    obj_ari.depth,
                    spr_fx_poof1_dirt_once
                );
                ARI.gain_essence(_shovel.prototype.quality + 1, 8 * (_cell_x + 1), 8 * (_cell_y + 1));
                ARI.modify_stamina(_shovel.prototype.stamina_cost);
                ARI.gain_xp(Skill.Archaeology, XpValue.break_dig_spot);
                _rt.dug_this_scan = true;
            }
        }
    }
}

function harvest_horse_boost_try_auto_dismount() {
    if (!obj_ari.is_mounted()) return;

    // Room transitions are regular instances, but the game's internal
    // overlap_instance() helper is not exposed to mod GML. The engine's
    // context-free point lookup gives us the same doorway check without
    // depending on a player-only method.
    var _transition = instance_position(obj_ari.x, obj_ari.y, obj_roomtransition);
    if (_transition != undefined
        && _transition.ari_can_use
        && LOCATIONS[_transition.destination_id] != undefined
        && !LOCATIONS[_transition.destination_id].outdoor)
    {
        // The mount state consumes this normal UI request and returns the
        // player to PlayerState.Default. The door transition then runs on
        // the following frame through the game's usual path.
        obj_ari.ui_mount_request = true;
    }
}

function harvest_horse_boost_tick() {
    if (!instance_exists(obj_ari)) return;

    var _rt = __harvest_horse_boost_runtime();
    var _cfg = harvest_horse_boost_config();
    var _mounted = obj_ari.is_mounted();

    if (_cfg.auto_dismount_indoors) {
        harvest_horse_boost_try_auto_dismount();
    }

    // A room transition can briefly report the player as unmounted. Wait for a
    // stable state before scanning or notifying, so map changes stay quiet.
    if (_rt.observed_mounted != _mounted) {
        _rt.observed_mounted = _mounted;
        _rt.stable_frames = 0;
        _rt.last_x = obj_ari.x;
        _rt.last_y = obj_ari.y;
        return;
    }
    if (_rt.stable_frames < HARVEST_HORSE_BOOST_SETTLE_FRAMES) {
        _rt.stable_frames += 1;
        _rt.last_x = obj_ari.x;
        _rt.last_y = obj_ari.y;
        return;
    }
    if (_rt.active_mounted != _mounted) {
        _rt.active_mounted = _mounted;
        harvest_horse_boost_notify_mode(_mounted, _cfg);
    }

    var _moved = (_rt.last_x != obj_ari.x || _rt.last_y != obj_ari.y);
    _rt.last_x = obj_ari.x;
    _rt.last_y = obj_ari.y;
    if (!_moved) return;

    _rt.scan_frame += 1;
    if ((_rt.scan_frame mod HARVEST_HORSE_BOOST_SCAN_INTERVAL) != 0) return;

    var _radius = _mounted ? _cfg.mounted_radius_tiles : _cfg.foot_radius_tiles;
    harvest_horse_boost_scan(_radius);
    if (_mounted && _cfg.mounted_auto_shovel) {
        harvest_horse_boost_scan_dig_sites(_radius);
    }
}

function harvest_horse_boost_register() {
    var _rt = __harvest_horse_boost_runtime();
    if (_rt.registered) return;
    _rt.registered = true;
    mmapi_register(harvest_horse_boost_tick);
}

mmapi_mod_declare("harvest_horse_boost", "1.1.3");
harvest_horse_boost_register();
