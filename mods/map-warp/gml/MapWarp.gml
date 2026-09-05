// Map Warp
// Adds a confirmed, fixed-destination warp action to the game's map menu.

function __map_warp_runtime() {
    if (global[$ "__map_warp"] == undefined) {
        global.__map_warp = { registered: false };
    }
    return global.__map_warp;
}

function map_warp_is_outdoor_target(_location_id) {
    return matches(
        _location_id,
        LocationId.Farm,
        LocationId.Town,
        LocationId.Narrows,
        LocationId.HaydensFarm,
        LocationId.Beach,
        LocationId.WesternRuins,
        LocationId.Summit,
        LocationId.EasternRoad,
        LocationId.DeepWoods,
        LocationId.DragonswornGlade
    );
}

function map_warp_is_unlocked(_location_id) {
    switch (_location_id) {
        case LocationId.DeepWoods:
            return world_mod_enabled(WorldMod.ThornyStairs);
        case LocationId.DragonswornGlade:
            return world_mod_enabled(WorldMod.DragonswornGlade);
        default:
            return true;
    }
}

function map_warp_destination(_location_id) {
    // Fixed, walkable arrival points taken from the game's location data.
    // Keeping them here avoids selecting a source-dependent room transition.
    switch (_location_id) {
        case LocationId.Farm:             return Vec2(1032, 124);
        case LocationId.Town:             return Vec2(1096, 1080);
        case LocationId.Narrows:          return Vec2(1350, 880);
        case LocationId.HaydensFarm:      return Vec2(1184, 680);
        case LocationId.Beach:            return Vec2(1736, 136);
        case LocationId.WesternRuins:     return Vec2(1664, 1008);
        case LocationId.Summit:           return Vec2(1016, 760);
        case LocationId.EasternRoad:      return Vec2(800, 1472);
        case LocationId.DeepWoods:        return Vec2(1344, 1328);
        case LocationId.DragonswornGlade: return Vec2(1208, 1200);
    }
    return undefined;
}

function map_warp_show_confirmation(_map_menu) {
    if (_map_menu == undefined || _map_menu.selected_location_id == undefined) return;

    var _location_id = _map_menu.selected_location_id;
    if (!map_warp_is_outdoor_target(_location_id)) return;

    if (!map_warp_is_unlocked(_location_id)) {
        var _locked_popup = popup_creator(
            "misc_local/confirmation",
            ANCHOR.wrap_for_local("この地域はまだ解放されていません。")
        );
        _locked_popup.create_button("misc_local/close");
        _locked_popup.spawn();
        return;
    }

    if (CURRENT_LOCATION_ID == _location_id || TAXI.is_traveling()) return;

    var _popup = popup_creator(
        "misc_local/confirmation",
        ANCHOR.wrap_for_local("ワープしますか？")
    );
    _popup.create_button("misc_local/cancel");
    _popup.create_button("misc_local/yes", map_warp_confirm, [_map_menu, _location_id]);
    _popup.spawn();
}

function map_warp_confirm(_map_menu, _location_id) {
    if (TAXI.is_traveling()
        || !map_warp_is_outdoor_target(_location_id)
        || !map_warp_is_unlocked(_location_id))
    {
        return;
    }

    var _destination = map_warp_destination(_location_id);
    if (_destination == undefined) return;

    // Explicitly set the destination's safe position. This makes the arrival
    // point fixed instead of depending on the region the player came from.
    _map_menu.close();
    goto_location_id(_location_id, true)
        .set_exact_position(_destination.x, _destination.y);
}

function map_warp_attach_button(_probe, _map_menu) {
    if (_probe.freed || _probe.blackboard.contains_key("__map_warp_attached")) return;
    if (_map_menu == undefined
        || _map_menu.selected_location_id == undefined
        || _map_menu.grid == undefined)
    {
        return;
    }

    _probe.board_set("__map_warp_attached", true);
    // Anchor directly to the map grid so this remains fixed for every map.
    var _button = ANCHOR.nine_slice(_map_menu.grid)
        .set_align(Align.RightIn, Align.TopIn)
        .set_xy(-10, 10)
        .set_size(92, COMMON_BUTTON_HEIGHT)
        .set_sprites_from_key("spr_ui_button")
        .add_hover_outline()
        .set_tap_callback(map_warp_show_confirmation, [_map_menu]);
    ANCHOR.text(_button)
        .set_align(Align.Center, Align.Middle)
        .set_lut(COMMON_LUT, CommonLutIndex.Dark)
        .set_text("ここへワープ");
    _button.set_think_callback(function(_button, _map_menu) {
        var _valid = _map_menu != undefined
            && _map_menu.selected_location_id != undefined
            && map_warp_is_outdoor_target(_map_menu.selected_location_id)
            && map_warp_is_unlocked(_map_menu.selected_location_id)
            && CURRENT_LOCATION_ID != _map_menu.selected_location_id
            && !TAXI.is_traveling();
        _button.set_unlocked(_valid);
        _button.set_alpha(_valid ? 1 : 0.5);
    }, [_button, _map_menu]);
}

function map_warp_on_menu_opened(_ctx) {
    var _map_menu = _ctx[$ "menu"];
    if (_map_menu == undefined || _map_menu[$ "type"] != Menu.Map) return;

    var _probe = ANCHOR.positional(_map_menu.grid).set_size(1, 1);
    _probe.set_think_callback(map_warp_attach_button, [_probe, _map_menu]);
}

function map_warp_register() {
    var _rt = __map_warp_runtime();
    if (_rt.registered) return;
    _rt.registered = true;
    mmapi_on("ui.menu_opened", map_warp_on_menu_opened);
}

mmapi_mod_declare("map_warp", "0.1.5");
map_warp_register();
