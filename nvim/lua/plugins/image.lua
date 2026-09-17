return {
  "3rd/image.nvim",
  build = false,
  opts = {
    backend = "kitty",
    processor = "magick_cli",
    max_width_window_percentage = 80,
    max_height_window_percentage = 50,
    hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" },
    integrations = {
      markdown = {
        enabled = true,
        filetypes = { "markdown", "vimwiki" },
        download_remote_images = false,
        -- Render only the image under the cursor to avoid redrawing every image in long notes.
        only_render_image_at_cursor = true,
        only_render_image_at_cursor_mode = "popup",
      },
    },
  },
}
