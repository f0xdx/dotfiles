if "unsupported" then
  return
end

local ok, llm = pcall(require, "llm")
if not ok then
  vim.notify("llm module not found")
  return
end

local which = vim.fn.exepath

llm.setup({
  -- specific config for backend / model
  -- see: https://github.com/huggingface/llm.nvim
  backend = "huggingface", -- backend ID, "huggingface" | "ollama" | "openai" | "tgi"

  -- model = "deepseek-ai/deepseek-coder-6.7b-base",
  -- tokens_to_clear = { "<|EOT|>" },
  -- fim = {
  --   enabled = true,
  --   prefix = "<|fim_begin|>",
  --   middle = "<|fim_hole|>",
  --   suffix = "<|fim_end|>",
  -- },
  -- context_window = 16384,
  -- tokenizer = {
  --   repository = "deepseek-ai/deepseek-coder-6.7b-base",
  -- },

  model = "codellama/CodeLlama-13b-hf",
  request_body = {
    parameters = {
      max_new_tokens = 256,
      temperature = 0.2,
      top_p = 0.95,
      top_k =10,
    },
  },
  tokens_to_clear = { "<EOT>" },
  fim = {
    enabled = true,
    prefix = "<PRE> ",
    middle = " <MID>",
    suffix = " <SUF>",
  },
  context_window = 4096,
  tokenizer = {
    repository = "codellama/CodeLlama-13b-hf",
  },

  -- /specific config

  lsp = {
    bin_path = which("llm-ls")
  },

  -- suggestion behavior
  -- see: https://github.com/huggingface/llm.nvim?tab=readme-ov-file#suggestion-behavior
  enable_suggestions_on_startup = false,
  debounce_ms = 300,
  accept_keymap = "<C-y>",
  dismiss_keymap = "<C-e>",
})

-- TODO switch to a local model with backend=tgi after having built a tgi flake
-- and enabled a systemD unit for it - this can then pull and host the model on
-- the local machine
--
-- TODO switch to a declarative way of providing model configurations, including
-- hot reloading (text vs. code editing, switch models as needed)
