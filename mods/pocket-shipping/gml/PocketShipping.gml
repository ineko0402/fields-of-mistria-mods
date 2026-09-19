// Pocket Shipping
// Turns the player inventory's trash button into an immediate shipping action.

#macro POCKET_SHIPPING_CONFIG_VERSION 2

function __pocket_shipping_runtime() {
    if (global[$ "__pocket_shipping"] == undefined) {
        global.__pocket_shipping = {
            registered: false,
            cfg: undefined,
        };
    }
    return global.__pocket_shipping;
}

function pocket_shipping_config() {
    var _rt = __pocket_shipping_runtime();
    if (_rt.cfg != undefined) return _rt.cfg;

    var _source = mmapi_config_load("pocket_shipping");
    _rt.cfg = {
        enabled: mmapi_config_bool(_source, "enabled", true),
        show_gold_feedback: mmapi_config_bool(_source, "show_gold_feedback", true),
    };
    mmapi_config_write("pocket_shipping", POCKET_SHIPPING_CONFIG_VERSION, _rt.cfg);
    return _rt.cfg;
}

function pocket_shipping_can_sell(_item) {
    return _item != undefined
        && !item_is_soulbound(_item.item_id)
        && _item.bin_value() > 0;
}

function pocket_shipping_update_trash_button(_menu) {
    if (_menu == undefined || _menu.inventory == undefined || _menu.trash_icon == undefined) return;

    var _item = _menu.inventory.hand.slot(0).item;
    var _cfg = pocket_shipping_config();
    _menu.trash_icon.set_unlocked(_cfg.enabled && pocket_shipping_can_sell(_item));
}

function pocket_shipping_sell_hand(_menu) {
    if (_menu == undefined || _menu.inventory == undefined) return;

    var _slot = _menu.inventory.hand.slot(0);
    var _item = _slot.item;
    if (!pocket_shipping_can_sell(_item)) {
        TANGO.play("SoundEffects/UI/UIUnableToInteract");
        return;
    }

    // Match the vanilla trash button: one item normally, the whole held stack
    // while Shift is held. bin_value() is the exact value used by shipping bins
    // and includes relevant quality and archaeology-perk bonuses.
    var _count = keyboard_check(vk_shift) ? _slot.count : 1;
    if (_count <= 0) return;

    var _gold = _item.bin_value() * _count;
    _slot.remove(_count);
    ARI.modify_gold(_gold);

    // Keep the meaningful parts of the normal overnight shipping record. In
    // particular, item-sale unlocks still see this as a legitimate sale.
    ARI.items_sold[_item.item_id] += _count;
    ARI.pending_renown_entries.push(RenownEntry.Gold(_gold));
}

function pocket_shipping_attach_to_player_menu(_probe, _menu) {
    if (_probe.freed || _menu == undefined || _menu.trash_icon == undefined) return;
    if (_menu.trash_icon.blackboard.contains_key("__pocket_shipping")) return;

    var _cfg = pocket_shipping_config();
    if (!_cfg.enabled) return;

    // The inventory page's built-in gold text is intentionally static. Reuse
    // the game's store gold widget instead: it observes ARI.gold live and
    // shows the standard animated +amount feedback after each sale.
    if (_cfg.show_gold_feedback && _menu[$ "__pocket_shipping_gold_feedback"] != true) {
        var _create_gold_widget = method(_menu, player_gold_prefab);
        _create_gold_widget(_menu);
        _menu.__pocket_shipping_gold_feedback = true;
    }

    _menu.trash_icon.board_set("__pocket_shipping", true);
    _menu.trash_icon.set_tap_sound("SoundEffects/UI/UIIncrement");
    _menu.trash_icon.set_tap_callback(pocket_shipping_sell_hand, [_menu], true);
    _menu.trash_icon.set_think_callback(pocket_shipping_update_trash_button, [_menu]);
}

function pocket_shipping_on_menu_opened(_ctx) {
    var _menu = _ctx[$ "menu"];
    if (_menu == undefined || _menu[$ "type"] != Menu.Player) return;

    // The player menu is rebuilt each time its journal tab is opened. This
    // lightweight probe waits until the vanilla trash button exists, then
    // replaces only that button's callback for this menu instance.
    var _probe = ANCHOR.positional(_menu.journal.right_page).set_size(1, 1);
    _probe.set_think_callback(pocket_shipping_attach_to_player_menu, [_probe, _menu]);
}

function pocket_shipping_register() {
    var _rt = __pocket_shipping_runtime();
    if (_rt.registered) return;
    _rt.registered = true;
    mmapi_on("ui.menu_opened", pocket_shipping_on_menu_opened);
}

mmapi_mod_declare("pocket_shipping", "0.1.0");
pocket_shipping_register();
