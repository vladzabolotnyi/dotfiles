return {
  "derektata/lorem.nvim",
  config = function()
    require("lorem").opts({
      sentence_length = "medium",
      comma_chance = 0.2,
      max_commas = 2,
      complete = {
        ft = { "text", "markdown", "html", "templ" },
      },
    })
  end,
}
