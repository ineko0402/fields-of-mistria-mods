// Mine Combat Boost
// Small, opt-in assists for Rockclod projectiles and mushroom shells.

#macro MINE_COMBAT_BOOST_CONFIG_VERSION 1
#macro MINE_COMBAT_BOOST_TILE_PIXELS 16

function __mine_combat_boost_runtime() {
    if (global[$ "__mine_combat_boost"] == undefined) {
        global.__mine_combat_boost = {
            registered: false,
            cfg: undefined,
            notified: false,
        };
    }
    return global.__mine_combat_boost;
}

function mine_combat_boost_config() {
    var _rt = __mine_combat_boost_runtime();
    if (_rt.cfg != undefined) return _rt.cfg;

    var _source = mmapi_config_load("mine_combat_boost");
    _rt.cfg = {
        enabled: mmapi_config_bool(_source, "enabled", true),
        auto_reflect_rocks: mmapi_config_bool(_source, "auto_reflect_rocks", true),
        auto_reflect_charges: mmapi_config_bool(_source, "auto_reflect_charges", true),
        auto_capture_bombs: mmapi_config_bool(_source, "auto_capture_bombs", true),
        mushroom_shell_break: mmapi_config_bool(_source, "mushroom_shell_break", true),
        assist_radius_tiles: mmapi_config_number(_source, "assist_radius_tiles", 1.5, 1, 3),
        debug_notifications: mmapi_config_bool(_source, "debug_notifications", false),
    };
    mmapi_config_write("mine_combat_boost", MINE_COMBAT_BOOST_CONFIG_VERSION, _rt.cfg);
    return _rt.cfg;
}

function mine_combat_boost_in_range(_x, _y, _radius_pixels) {
    return point_distance(_x, _y, obj_ari.x, obj_ari.y) <= _radius_pixels;
}

function mine_combat_boost_reflect_rocks(_radius_pixels) {
    // reflect() is the Rockclod projectile's native counterattack path. It
    // creates the enemy-targeting projectile with the original owner/stats;
    // destroying the incoming instance mirrors its normal on_hit() flow.
    with (obj_monster_clod_projectile) {
        if (self.captured != true
            && self.target == CombatTarget.Player
            && mine_combat_boost_in_range(self.x, self.y, _radius_pixels))
        {
            self.reflect(self.dmg);
            instance_destroy(self);
        }
    }
}

function mine_combat_boost_reflect_charges(_radius_pixels) {
    // A flying Rockclod has a built-in reflected state: its attack tarball is
    // retargeted, its flight reverses, and a later wall collision finishes it.
    // Set that state exactly once, then send one damage event through the
    // monster's own receiver. Using the Rockclod as source preserves the
    // game's full-damage path instead of its normal 1-damage melee fallback.
    with (obj_monster_clod) {
        if (self.fsm != undefined
            && self.fsm.current_state_id() == RockclodState.Flying
            && mine_combat_boost_in_range(self.x, self.y, _radius_pixels))
        {
            var _state = self.fsm.current_state();
            if (_state != undefined
                && _state.reflected == false
                && _state.reflection_cd <= 0)
            {
                _state.reflected = true;
                _state.reflection_cd = 5;
                if (_state.tarball != undefined && instance_exists(_state.tarball)) {
                    _state.tarball.target = CombatTarget.Enemy;
                    _state.tarball.damage *= 2;
                }
                _state.spd.set_scale(-self.config.reflect_speed);
                self.dir += 180;

                mmapi_deal_damage(self, self.config.damage, {
                    source: self,
                    pierce_iframes: true,
                    heavy: true,
                });
            }
        }
    }
}

function mine_combat_boost_capture_bombs(_radius_pixels) {
    // This follows the bug-net reward semantics, except it deliberately does
    // not consume stamina or trigger a tool animation. Never destroy a bomb
    // when there is no inventory room: the player can still capture or evade it.
    with (obj_monster_clod_bomb) {
        if (self.captured != true
            && mine_combat_boost_in_range(self.x, self.y, _radius_pixels)
            && ARI.inventory != undefined
            && ARI.inventory.can_add(ItemId.Bomb))
        {
            self.captured = true;
            ARI.give_item(ItemId.Bomb, 1, true, true, true);
            instance_destroy(self);
        }
    }
}

function mine_combat_boost_damage_filter(_tarball, _receiver) {
    var _cfg = mine_combat_boost_config();
    if (!_cfg.enabled || !_cfg.mushroom_shell_break) return _tarball;
    if (_tarball == undefined || !instance_exists(_tarball)) return _tarball;
    if (_receiver == undefined || !instance_exists(_receiver)) return _tarball;

    // Enemy-targeting hits against mushrooms receive the engine's supported
    // ShieldBreak flag. The mushroom still performs its own normal hit logic.
    if (_tarball.target == CombatTarget.Enemy
        && _receiver.parent_object_id == obj_monster_shroom)
    {
        _tarball.flags |= CombatFlag.ShieldBreak;
    }
    return _tarball;
}

function mine_combat_boost_tick() {
    if (!instance_exists(obj_ari)) return;

    var _rt = __mine_combat_boost_runtime();
    var _cfg = mine_combat_boost_config();
    if (!_cfg.enabled) return;

    if (_cfg.debug_notifications && !_rt.notified) {
        _rt.notified = true;
        create_notification("mods/mine_combat_boost/notifications/active");
    }

    var _radius_pixels = _cfg.assist_radius_tiles * MINE_COMBAT_BOOST_TILE_PIXELS;
    if (_cfg.auto_reflect_rocks) {
        mine_combat_boost_reflect_rocks(_radius_pixels);
    }
    if (_cfg.auto_reflect_charges) {
        mine_combat_boost_reflect_charges(_radius_pixels);
    }
    if (_cfg.auto_capture_bombs) {
        mine_combat_boost_capture_bombs(_radius_pixels);
    }
}

function mine_combat_boost_register() {
    var _rt = __mine_combat_boost_runtime();
    if (_rt.registered) return;
    _rt.registered = true;
    mmapi_register(mine_combat_boost_tick);
    mmapi_filter("combat.damage", mine_combat_boost_damage_filter);
}

mmapi_mod_declare("mine_combat_boost", "0.1.2");
mine_combat_boost_register();
