local scenes = require "scenes"

local successResolver = {
  resolve = function(modifiers, observer)
    observer:totalSuccess()
  end
}

local partialResolver = {
  resolve = function(modifiers, observer)
    observer:partialSuccess()
  end
}

local missResolver = {
  resolve = function(modifiers, observer)
    observer:miss()
  end
}

describe("hang", function()
  local student1, student2

  before_each(function()
    student1 = {
      id = 1,
      mood = 5,
      relationships = {
        { studentId = 5, drama = 0 },
        { studentId = 2, drama = 0 },
        { studentId = 3, drama = 0 }
      }
    }

    student2 = {
      id = 2,
      mood = 5,
      relationships = {
        { studentId = 1, drama = 0 }
      }
    }
  end)

  describe("total success", function()
    before_each(function()
      scenes.hang(student1, student2, successResolver)
    end)

    it("increases each student's mood by 1", function()
      assert.are.equals(6, student1.mood)
      assert.are.equals(6, student2.mood)
    end)
  end)

  describe("partial success", function()
    before_each(function()
      scenes.hang(student1, student2, partialResolver)
    end)

    it("increases each student's mood by 1", function()
      assert.are.equals(6, student1.mood)
      assert.are.equals(6, student2.mood)
    end)

    it("increases the subject's drama with the object by 1", function()
      assert.are.equals(1, student1.relationships[2].drama)
    end)
  end)

  describe("miss", function()
    before_each(function()
      scenes.hang(student1, student2, missResolver)
    end)

    it("decreases each student's mood by 1", function()
      assert.are.equals(4, student1.mood)
      assert.are.equals(4, student2.mood)
    end)

    it("increases each student's drama with the other by 1", function()
      assert.are.equals(1, student1.relationships[2].drama)
      assert.are.equals(1, student2.relationships[1].drama)
    end)
  end)
end)
