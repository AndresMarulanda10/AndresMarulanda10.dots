return {
  "iamcco/markdown-preview.nvim",
  cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
  ft = { "markdown" },
  build = "cd app && npm install",
  init = function()
    -- Browser preview is for HTML-heavy READMEs; MarkdownPreviewStop is the manual fallback.
    vim.g.mkdp_auto_start = 0
    vim.g.mkdp_auto_close = 1
    vim.g.mkdp_open_to_the_world = 0
    vim.g.mkdp_browser = ""
    vim.g.mkdp_port = ""
    vim.g.mkdp_filetypes = { "markdown" }

    -- Stop the server when leaving Markdown, rather than keeping it until Vim exits.
    local group = vim.api.nvim_create_augroup("MarkdownPreviewLifecycle", { clear = true })
    vim.api.nvim_create_autocmd({ "BufLeave", "BufHidden" }, {
      group = group,
      callback = function(args)
        if not vim.api.nvim_buf_is_valid(args.buf) or vim.bo[args.buf].filetype ~= "markdown" then
          return
        end

        vim.api.nvim_buf_call(args.buf, function()
          if vim.fn.exists(":MarkdownPreviewStop") == 2 then
            vim.cmd("silent! MarkdownPreviewStop")
          end
        end)
      end,
    })
  end,
}
