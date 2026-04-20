-- Completion engine with source labels, kind icons, and docs
return {
    'saghen/blink.cmp',
    version = '1.*',
    event = 'InsertEnter',
    dependencies = {
        'rafamadriz/friendly-snippets',
    },
    opts = {
        keymap = { preset = 'default' },
        appearance = {
            nerd_font_variant = 'mono',
        },
        completion = {
            menu = {
                draw = {
                    columns = {
                        { 'label', 'label_description', gap = 1 },
                        { 'kind_icon', 'kind', gap = 1 },
                        { 'source_name' },
                    },
                },
            },
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 200,
            },
            ghost_text = {
                enabled = true,
            },
        },
        signature = { enabled = true },
        sources = {
            default = { 'lsp', 'path', 'snippets', 'buffer' },
        },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
}
