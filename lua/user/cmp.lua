local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  return
end

--   פּ ﯟ   some other good icons
local kind_icons = {
  Text = "",
  Method = "m",
  Function = "",
  Constructor = "",
  Field = "",
  Variable = "",
  Class = "",
  Interface = "",
  Module = "",
  Property = "",
  Unit = "",
  Value = "",
  Enum = "",
  Keyword = "",
  Snippet = "",
  Color = "",
  File = "",
  Reference = "",
  Folder = "",
  EnumMember = "",
  Constant = "",
  Struct = "",
  Event = "",
  Operator = "",
  TypeParameter = "",
}
-- find more here: https://www.nerdfonts.com/cheat-sheet

local feedkeys = require'cmp.utils.feedkeys'

local t = function (str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup {
  snippet = {
    expand = function(args)
       vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.   luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    -- snippet movement with vsnips
    ['<C-j>'] = cmp.mapping(function (fallback)
        if vim.fn['vsnip#jumpable'](1) == 1 then
            feedkeys.call(t"<Plug>(vsnip-jump-next)", "")
        else
            fallback()
        end
    end, { 'i', 's', 'c' }),
    ['<C-h>'] = cmp.mapping(function (fallback)
        if vim.fn['vsnip#jumpable'](-1) == 1 then
            feedkeys.call(t"<Plug>(vsnip-jump-prev)", "")
        else
            fallback()
        end
    end, { 'i', 's', 'c' }),
  }),
  formatting = {
    fields = { "kind", "abbr", "menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
  confirm_opts = {
    behavior = cmp.ConfirmBehavior.Replace,
    select = false,
  },
  window = {
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
    },
  },
  experimental = {
    ghost_text = false,
    native_menu = false,
  },
}
