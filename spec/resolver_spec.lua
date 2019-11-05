local Resolver = require "resolver"

local constantRoller = { value = 0 }
function constantRoller:roll()
  return self.value
end
function constantRoller:set(value)
  self.value = value
end

local observer = { lastCall = "no calls yet" }
function observer:totalSuccess() self.lastCall = "totalSuccess" end
function observer:partialSuccess() self.lastCall = "partialSuccess" end
function observer:miss() self.lastCall = "miss" end

describe("resolve", function()
  local resolver

  before_each(function()
    resolver = Resolver:new{roller = constantRoller}
  end)

  describe("on a 7 to 9", function()
    it("calls partialSuccess on the observer", function()
      constantRoller:set(8)

      resolver:resolve(0, observer)

      assert.are.equals("partialSuccess", observer.lastCall)
    end)
  end)
end)
