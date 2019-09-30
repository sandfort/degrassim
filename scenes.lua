-- observer for hang scenes
local HangObserver = {}

function HangObserver:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function HangObserver:totalSuccess()
  self.subject.mood = self.subject.mood + 1
  self.object.mood = self.object.mood + 1
end

function findRelationship(relationships, id)
  for _, r in ipairs(relationships) do
    if r.studentId == id then
      return r
    end
  end
end

function HangObserver:partialSuccess()
  self.subject.mood = self.subject.mood + 1
  self.object.mood = self.object.mood + 1

  local relationship = findRelationship(self.subject.relationships, self.object.id)

  relationship.drama = relationship.drama + 1
end

function HangObserver:miss()
  self.subject.mood = self.subject.mood - 1
  self.object.mood = self.object.mood - 1

  local r1 = findRelationship(self.subject.relationships, self.object.id)
  local r2 = findRelationship(self.object.relationships, self.subject.id)

  r1.drama = r1.drama + 1
  r2.drama = r2.drama + 1
end

scenes = {}

-- the hang scene itself
function scenes.hang(subject, object, resolver)
  local observer = HangObserver:new{subject = subject, object = object}
  resolver.resolve(0, observer)
end

return scenes
