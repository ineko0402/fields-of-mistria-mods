// Proximity Crop Harvest
// Automatically interacts with mature field crops near a moving player.

#macro PROXIMITY_CROP_HARVEST_CONFIG_VERSION 1
#macro PROXIMITY_CROP_HARVEST_SETTLE_FRAMES 12
#macro PROXIMITY_CROP_HARVEST_SCAN_INTERVAL 3
#macro PROXIMITY_CROP_HARVEST_TILE_PIXELS 32

function __proximity_crop_harvest_runtime() {
    if (global[$ "__proximity_crop_harvest"] == undefined) {
        global.__proximity_crop_harvest = {
            registered: false,
            cfg: undefined,
            observed_mounted: undefined,
            active_mounted: undefined,
            stable_frames: 0,
            last_x: undefined,
            last_y: undefined,
            scan_frame: 0,
        };
    }
    return global.__proximity_crop_harvest;
}

function proximity_crop_harvest_config() {
    var _rt = __proximity_crop_harvest_runtime();
    if (_rt.cfg != undefined) return _rt.cfg;

    var _source = mmapi_config_read_valid("proximity_crop_harvest", PROXIMITY_CROP_HARVEST_CONFIG_VERSION);
    _rt.cfg = {
        foot_radius_tiles: mmapi_config_number(_source, "foot_radius_tiles", 1, 0, 4),
        mounted_radius_tiles: mmapi_config_number(_source, "mounted_radius_tiles", 2, 0, 4),
        harvest_fruit_bushes: mmapi_config_bool(_source, "harvest_fruit_bushes", true),
        harvest_fruit_trees: mmapi_config_bool(_source, "harvest_fruit_trees", true),
        debug_notifications: mmapi_config_bool(_source, "debug_notifications", true),
    };
    mmapi_config_write("proximity_crop_harvest", PROXIMITY_CROP_HARVEST_CONFIG_VERSION, _rt.cfg);
    return _rt.cfg;
}

function proximity_crop_harvest_notify_mode(_mounted, _cfg) {
    if (!_cfg.debug_notifications) return;
    if (_mounted) {
        create_notification("mods/proximity_crop_harvest/notifications/mounted");
    } else {
        create_notification("mods/proximity_crop_harvest/notifications/on_foot");
    }
}

function proximity_crop_harvest_is_target(_node, _cfg) {
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

function proximity_crop_harvest_scan(_radius_tiles) {
    var _radius_pixels = (_radius_tiles * PROXIMITY_CROP_HARVEST_TILE_PIXELS) + (PROXIMITY_CROP_HARVEST_TILE_PIXELS / 2);
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
            && proximity_crop_harvest_is_target(_node, __proximity_crop_harvest_runtime().cfg)
            && abs(self.x - _player_x) <= _radius_pixels
            && abs(self.y - _player_y) <= _radius_pixels
            && can_interact(_node))
        {
            interact(_node);
        }
    }
}

function proximity_crop_harvest_tick() {
    if (!instance_exists(obj_ari)) return;

    var _rt = __proximity_crop_harvest_runtime();
    var _cfg = proximity_crop_harvest_config();
    var _mounted = obj_ari.is_mounted();

    // A room transition can briefly report the player as unmounted. Wait for a
    // stable state before scanning or notifying, so map changes stay quiet.
    if (_rt.observed_mounted != _mounted) {
        _rt.observed_mounted = _mounted;
        _rt.stable_frames = 0;
        _rt.last_x = obj_ari.x;
        _rt.last_y = obj_ari.y;
        return;
    }
    if (_rt.stable_frames < PROXIMITY_CROP_HARVEST_SETTLE_FRAMES) {
        _rt.stable_frames += 1;
        _rt.last_x = obj_ari.x;
        _rt.last_y = obj_ari.y;
        return;
    }
    if (_rt.active_mounted != _mounted) {
        _rt.active_mounted = _mounted;
        proximity_crop_harvest_notify_mode(_mounted, _cfg);
    }

    var _moved = (_rt.last_x != obj_ari.x || _rt.last_y != obj_ari.y);
    _rt.last_x = obj_ari.x;
    _rt.last_y = obj_ari.y;
    if (!_moved) return;

    _rt.scan_frame += 1;
    if ((_rt.scan_frame mod PROXIMITY_CROP_HARVEST_SCAN_INTERVAL) != 0) return;

    var _radius = _mounted ? _cfg.mounted_radius_tiles : _cfg.foot_radius_tiles;
    proximity_crop_harvest_scan(_radius);
}

function proximity_crop_harvest_register() {
    var _rt = __proximity_crop_harvest_runtime();
    if (_rt.registered) return;
    _rt.registered = true;
    mmapi_register(proximity_crop_harvest_tick);
}

mmapi_mod_declare("proximity_crop_harvest", "1.0.0");
proximity_crop_harvest_register();
