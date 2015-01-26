local bigTable = {}

for i = 1, 100000 do
	bigTable[i] = display.newGroup()
end
print("Done requiring memSink!")