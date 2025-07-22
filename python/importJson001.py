import json

# https://pynative.com/python-convert-json-string-to-dictionary-not-list/

sampleList = [125, 23, 85, 445]

# Serialization
print("serialize into JSON and write into a file")
with open("sampleFile.json", "w") as write_file:
    json.dump(sampleList, write_file)
print("Done Writing into a file")

# Deserialization
print("Started Reading JSON data from file")
with open("sampleFile.json", "r") as read_file:
    data = json.load(read_file)
print("Type of deserialized data: ", type(data))


print("Data is")
for i in data:
    print(i)
    
print ('-------------------------------------------------------------------------\n')

StudentDict = {"id": 22, "name": "Emma"}
MarksList = [StudentDict, 78, 56, 85, 67]

# Serialization
encodedJson = json.dumps(MarksList, indent=4)

# Deserialization

data = json.loads(encodedJson) # or you can read from file using load()
print("Type of deserialized data: ", type(data))

print("JSON Data is")
for i in data:
    if isinstance(i, dict):
         for key, value in i.items():
                theKey = key 
                if theKey=='name':
                        print(key, value)

'''
print("JSON Data is")
for i in data:
    if isinstance(i, dict):
        for key, value in i.items():
            print(key, value)
    else:
        print(i)
'''