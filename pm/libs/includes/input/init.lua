local prompt = require("includes/input/prompt")
local choice = require("includes/input/choice")
local waitKey = require("includes/input/waitKey")
local confirm = require("includes/input/confirm")

return {
  prompt = prompt,
  choice = choice,
  waitKey = waitKey.waitKey,
  waitAnyKey = waitKey.waitAnyKey,
  confirm = confirm,
}