local function craft()
  turtle.select(8)
  turtle.craft(1)
  turtle.dropUp(1)
end

return {
  craft = craft
}