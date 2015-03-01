-- =============================================================
-- Copyright Roaming Gamer, LLC. 2009-2015
-- =============================================================
-- String Add-ons
-- =============================================================
-- Short and Sweet License: 
-- 1. You may use anything you find in the SSKCorona library and sampler to make apps and games for free or $$.
-- 2. You may not sell or distribute SSKCorona or the sampler as your own work.
-- 3. If you intend to use the art or external code assets, you must read and follow the licenses found in the
--    various associated readMe.txt files near those assets.
--
-- Credit?:  Mentioning SSKCorona and/or Roaming Gamer, LLC. in your credits is not required, but it would be nice.  Thanks!
--
-- =============================================================
-- Docs: https://github.com/roaminggamer/SSKCorona/wiki
-- =============================================================

local strLen = string.len

-- ==
--    string:split( tok ) - Splits token (tok) separated string into integer indexed table.
-- ==
function string:split(tok)
	local str = self
	local t = {}  -- NOTE: use {n = 0} in Lua-5.0
	local ftok = "(.-)" .. tok
	local last_end = 1
	local s, e, cap = str:find(ftok, 1)
	while s do
		if s ~= 1 or cap ~= "" then
			table.insert(t,cap)
		end
		last_end = e+1
		s, e, cap = str:find(ftok, last_end)
	end
	if last_end <= #str then
		cap = str:sub(last_end)
		table.insert(t, cap)
	end
	return t
end

-- ==
--    string:getWord( index ) - Gets indexed word from string, where words are separated by a single space (' ').
-- ==
function string:getWord( index )
	local index = index or 1
	local aTable = self:split(" ")
	return aTable[index]
end

-- ==
--    string:getWordCount( ) - Counts words in a string, where words are separated by a single space (' ').
-- ==
function string:getWordCount( )
	local aTable = self:split(" ")
	return #aTable
end

-- ==
--    Words are separated by a single space (' ') - Gets indexed words from string, starting at index and ending at endindex or end of line if not specified.  
-- ==
function string:getWords( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split(" ")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.concat(tmpTable, " ")

	return tmpString
end

-- ==
--    string:setWord( index , replace ) - Replaces indexed word in string with replace, where words are separated by a single space (' ').
-- ==
function string:setWord( index, replace )
	local index = index or 1
	local aTable = self:split(" ")
	aTable[index] = replace
	local tmpString = table.concat(aTable, " ")
	return tmpString
end


-- ==
--    string:getField( index ) - Gets indexed field from string, where fields are separated by a single TAB ('\t').
-- ==
function string:getField( index )
	local index = index or 1
	local aTable = self:split("\t")
	return aTable[index]
end

-- ==
--    string:getFieldCount( ) - Counts fields in a string, where fields are separated by a single TAB ('\t').
-- ==
function string:getFieldCount( )
	local aTable = self:split("\t")
	return #aTable
end

-- ==
--    string:getFields( index [, endIndex ] ) - Gets indexed fields from string, starting at index and ending at endindex or end of line if not specified.  
-- ==
function string:getFields( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split("\t")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.concat(tmpTable, "\t")

	return tmpString
end

-- ==
--    string:setField( index , replace ) - Replaces indexed field in string with replace, where fields are separated by a single TAB ('\t').
-- ==
function string:setField( index, replace )
	local index = index or 1
	local aTable = self:split("\t")
	aTable[index] = replace
	local tmpString = table.concat(aTable, "\t")
	return tmpString
end

-- ==
--    string:getRecord( index ) - Gets indexed record from string, where records are separated by a single NEWLINE ('\n').
-- ==
function string:getRecord( index )
	local index = index or 1
	local aTable = self:split("\n")
	return aTable[index]
end

-- ==
--    string:getRecordCount( ) - Counts records in a string, where records are separated by a single NEWLINE ('\n').
-- ==
function string:getRecordCount( )
	local aTable = self:split("\n")
	return #aTable
end

-- ==
--    string:getRecords( index [, endIndex ] ) - Gets indexed records from string, starting at index and ending at endindex or end of line if not specified.  
-- ==
function string:getRecords( index, endindex )
	local index = index or 1
	local offset = index - 1
	local aTable = self:split("\n")
	local endindex = endindex or #aTable

	if(endindex > #aTable) then
		endindex = #aTable
	end

	local tmpTable = {}

	for i = index, endindex do
		tmpTable[i-offset] = aTable[i]
	end

	local tmpString = table.concat(tmpTable, "\n")

	return tmpString
end

-- ==
--    string:setRecord( index , replace ) - Replaces indexed record in string with replace, where records are separated by a single NEWLINE ('\n').
-- ==
function string:setRecord( index, replace )
	local index = index or 1
	local aTable = self:split("\n")
	aTable[index] = replace
	local tmpString = table.concat(aTable, "\n")
	return tmpString
end

-- ==
--    string:spaces2underbars( ) - Replaces all instances of spaces with underbars.
-- ==
function string:spaces2underbars( )
	return self:gsub( "%s", "_" )
end

-- ==
--    string:underbars2spaces( ) - Replaces all instances of underbars with spaces.
-- ==
function string:underbars2spaces( )
	return self:gsub( "_", " " )
end

-- ==
--    string:printf( ... ) - Replicates C-language printf().
-- ==
function string:printf(...)
	return io.write(self:format(...))
end -- function

-- ==
--    string:lpad( len, char ) - Places padding on left side of a string, such that the new string is at least len characters long.
-- ==
function string:lpad (len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return string.rep(char, len - #theStr) .. theStr
end

-- ==
--    string:rpad( len, char ) - Places padding on right side of a string, such that the new string is at least len characters long.
-- ==
function string:rpad(len, char)
	local theStr = self
    if char == nil then char = ' ' end
    return theStr .. string.rep(char, len - #theStr)
end

-- ==
--    Sergey Stuff - Nice bits from Sergey's code: https://gist.github.com/Lerg
-- ==
--    trim( s ) - EFM
function string.trim(s)
    local from = s:match"^%s*()"
    return from > #s and "" or s:match(".*%S", from)
end
--    startsWith( s, piece ) - EFM
function string.startswith(s, piece)
    return string.sub(s, 1, strLen(piece)) == piece
end
--    endsWith( s, piece ) - EFM
function string.endswith(s, send)
    return #s >= #send and s:find(send, #s-#send+1, true) and true or false
end


string.url_encode = function(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
  function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str    
end

string.url_encode = function(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w %-%_%.%~])", function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str  
end

string.url_decode = function( str )
  str = string.gsub (str, "+", " ")
  str = string.gsub (str, "%%(%x%x)", function(h) return string.char( tonumber(h,16) ) end )
  str = string.gsub (str, "\r\n", "\n")
  return str
end

string.strip_Control_Codes = function( str )
   local s = ""
   for i in str:gmatch( "%C+" ) do
      s = s .. i
   end
   return s
end
 
string.strip_Control_and_Extended_Codes = function( str )
   local s = ""
   for i = 1, str:len() do
      if str:byte(i) >= 32 and str:byte(i) <= 126 then
         s = s .. str:sub(i,i)
      end
   end
   return s
end

string.shorten = function( text, maxLen, appendMe )
  if not text then return "" end
  --print( text, maxLen, appendMe )
  appendMe = appendMe or ""
  local outText = text
  if(outText:len() > maxLen) then
    outText = outText:sub(1,maxLen) .. appendMe
  end
  return outText
end


-- ==
--    comma_value(val, n) - Converts a number to a comma separated string. (http://lua-users.org/wiki/FormattingNumbers)
--    val - The value to convert to comma separated string.
-- ==
function string.comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break
    end
  end
  return formatted
end