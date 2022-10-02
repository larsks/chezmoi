local cmp = require'cmp'

cmp.setup({
    completion = {
        autocomplete = false
    },
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' }, -- For vsnip users.
    }, {
        { name = 'buffer' },
    })
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        { name = 'cmdline' }
    })
})

function setAutoCmp(mode)
  if mode then
    cmp.setup({
      completion = {
        autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
      }
    })
    print("AutoComplete is On")
  else
    cmp.setup({
      completion = {
        autocomplete = false
      }
    })
    print("AutoComplete is Off")
  end
end

if (vim.g.cmp_toggle_flag == nil) then
    vim.g.cmp_toggle_flag = false
end

function toggleAutoCmp()
    vim.g.cmp_toggle_flag = not vim.g.cmp_toggle_flag
    setAutoCmp(vim.g.cmp_toggle_flag)
end

vim.cmd('command AutoCmpOn lua setAutoCmp(true)')
vim.cmd('command AutoCmpOff lua setAutoCmp(false)')
vim.cmd('command AutoCmpToggle lua toggleAutoCmp()')

vim.keymap.set('i', '<A-c>', toggleAutoCmp, {silent=true, noremap=true})
vim.keymap.set('n', '<Leader>tc', toggleAutoCmp, {silent=true, noremap=true})
