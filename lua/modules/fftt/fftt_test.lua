-- to run execute `:PlenaryBustedFile lua/modules/fftt/fftt_test.lua`

require("plenary.busted")

local fftt = require("modules.fftt")
fftt.setup()

describe("`prepare_str()`:", function()
  it("correct substring in English in `right` direction", function()
    local s = "This is line"
    local res = fftt.prepare_str(s, "left", 5)
    assert.are_same("s line", res)
  end)

  it("correct substring in English in `right` direction", function()
    local s = "This is line"
    local res = fftt.prepare_str(s, "right", 5)
    assert.are_same(" sihT", res)
  end)

  it("correct substring in Russian in `left` direction", function()
    local s = "Это строка"
    local res = fftt.prepare_str(s, "left", 10)
    assert.are_same("рока", res)
  end)

  it("correct substring in Russian in `right` direction", function()
    local s = "Это строка"
    local res = fftt.prepare_str(s, "right", 10)
    assert.are.are_same("с отЭ", res)
  end)
end)

describe("`calc_ranges()`:", function()
  it("Found expected letters with English in `left` direction", function()
    local s = "This is line on English language"
    local res = fftt.calc_ranges(s, "left", 1)
    assert.are_same(
      { "i", "l", "o", "E", "a" },
      vim
        .iter(res)
        :map(function(v)
          return v.char
        end)
        :totable()
    )
  end)

  it("Found expected letters with Russian in `left` direction", function()
    local s = "Эта строка на русском языке сызнова"
    local res = fftt.calc_ranges(s, "left", 1)
    assert.are_same(
      { "с", "н", "у", "я", "в" },
      vim
        .iter(res)
        :map(function(v)
          return v.char
        end)
        :totable()
    )
  end)

  it("Found expected letters with English in `left` direction with big spaces", function()
    local s = "This is              English line           with big spaces"
    local res = fftt.calc_ranges(s, "left", 1)
    assert.are_same(
      { "i", "E", "e", "w", "b", "p" },
      vim
        .iter(res)
        :map(function(v)
          return v.char
        end)
        :totable()
    )
  end)

  it("Found expected letters with English in `right` direction", function()
    local s = "This is line on English language"

    local res = fftt.calc_ranges(s, "right", 31)
    assert.are_same(
      { "h", "o", "e", "s", "T" },
      vim
        .iter(res)
        :map(function(v)
          return v.char
        end)
        :totable()
    )
  end)

  it("Found expected letters with Russian in `right` direction", function()
    local s = "Эта строка на русском языке сызнова"
    local res = fftt.calc_ranges(s, "right", 63)
    assert.are_same(
      { "е", "м", "а", "т", "Э" },
      vim
        .iter(res)
        :map(function(v)
          return v.char
        end)
        :totable()
    )
  end)

  it("Found expected letters with English in `right` direction with big spaces", function()
    local s = "This is              English line           with big spaces"
    local res = fftt.calc_ranges(s, "right", 58)
    assert.are_same(
      { "g", "h", "n", "E", "s", "T" },
      vim
        .iter(res)
        :map(function(v)
          return v.char
        end)
        :totable()
    )
  end)
end)
