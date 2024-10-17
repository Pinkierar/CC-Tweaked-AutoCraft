local prompt = require("includes/input/prompt")
local choice = require("includes/input/choice")
local waitKey = require("includes/input/waitKey")

return {
  prompt = prompt,
  choice = choice,
  waitKey = waitKey.waitKey,
  waitAnyKey = waitKey.waitAnyKey
}