-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>e", function()
  local explorer_picker = Snacks.picker.get({ source = "explorer" })[1]

  if explorer_picker then
    if explorer_picker.focus and explorer_picker.close then
      if explorer_picker:is_focused() then
        explorer_picker:close() -- If focused, close it
      else
        explorer_picker:focus() -- If open but not focused, focus it
      end
    end
  else
    Snacks.picker.explorer({ cwd = LazyVim.root() }) -- If not open, open it
  end
end, { desc = "Toggle Snacks Explorer" })
