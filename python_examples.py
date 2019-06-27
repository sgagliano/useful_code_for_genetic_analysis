#get number of characters
fileref = open("school_prompt2.txt","r")
contents = fileref.read()
num_char=len(contents)
fileref.close()

#get number of lines
fileref = open("travel_plans2.txt","r")
lines = fileref.readlines()
num_lines=0
for line in lines:
    num_lines=num_lines+1
fileref.close()

#output first 40 characters
fileref = open("emotion_words2.txt","r")
contents =fileref.read()
first_forty=contents[:40]
fileref.close()

#using with
with open('mydata.txt', 'r') as md:
    for line in md:
        print(line)

#write the words that have a p
fileref = open("school_prompt.txt","r")
lines = fileref.readlines()

p_words=[]

for line in lines:
    line=line.strip()
    words=line.split(' ')
    for word in words:
        if 'p' in word:
            p_words.append(word)
fileref.close()

#write
filename = "squared_numbers.txt"
outfile = open(filename, "w")

for number in range(1, 13):
    square = number * number
    outfile.write(str(square) + "\n")

outfile.close()

#Add to a dictionary called places (or update if key exists)
places['Brazil']=2016

#write the keys in a dictionary called medal_Events to a list called events
events=[]
for akey in medal_events:
    events.append(akey)

#dictionary example
medal_count = {'United States': 70, 'Great Britain': 38, 'China': 45, 'Russia': 30, 'Germany':17}

#assign the value for a specific key (‘Fencing’) in a dictionary (‘US_medals’) to ‘fencing_value’
fencing_value=''
for akey in US_medals:
    if akey=='Fencing':
        fencing_value=US_medals[akey]

#create a dictionary, freq_words, that sidplays each wor in string str1 as the key and its frequency as the value
str1 = "I wish I wish with all my heart to fly with dragons in a land apart"
freq_words = {} 
words=str1.split()
for word in words: 
    if word in freq_words: 
        freq_words[word] += 1
    else: 
        freq_words[word] = 1

#create the dictionary characters that shows each character from the string sally and its frequency. Then, find the #most frequent letter based on the dictionary. Assign this letter to the variable best_char
sally = "sally sells sea shells by the sea shore"
characters = {} 
for ch in sally: 
    if ch in characters: 
        characters[ch] += 1
    else: 
        characters[ch] = 1
max_value = max(characters.values())
best_char = [k for k, v in characters.items() if v == max_value]
best_char=best_char[0]

#write a function that adds up all the integers in a list
def total(lst):
    tot=0
    for num in lst:
        tot=tot+num
    return tot

#for a string of scores, count how many are over 90
a_scores=0
myscores=scores.split()
for score in myscores:
    if int(score) >=90:
        a_scores= a_scores+1

#for a string of words (that aren’t also found in a list called stopwords), take the first letter and capitalize 
acro=''
for word in org.split():
    if word not in stopwords:
        acro=acro+word[0].capitalize()

#for a string of words (that aren’t also found in a list called stopwords), take the first 2 letters, capitalize & reverse
acro=''
for word in sent.split():
    if word not in stopwords:
        acro=acro+word[0:2].upper() + '. '
acro=acro[:-2]

#reverse the letters string p_phrase and call it r_phrase, check if it’s palindromic
r_phrase=''
r_phrase_iter=reversed(p_phrase)
for char in r_phrase_iter:
    r_phrase=r_phrase+char
p_phrase==r_phrase

#create a sentence using the strings (with 3 values) in inventory
for item in inventory:
    itemcontent=item.split(',')
    my_output='The store has{} {}, each for{} USD.'
    
    print (my_output.format(itemcontent[1], itemcontent[0], itemcontent[2]))`

#get the number of rainy days (i.e. more than 3units)
accum=0
rainfall= rainfall_mi.split(',')

for rain in rainfall:
    if float(rain) >3.0:
        accum=accum+1
        
num_rainy_months=accum


#get the words in the sentence that begin and end with the same letter
count=0
words=sentence.split()
for word in words:
    if word[0]==word[-1]:
        count=count+1
same_letter_count=count

#cont the number of words with a w
items = ["whirring", "wow!", "calendar", "wry", "glass", "", "llama","tumultuous","owing"]
acc_num=0
for item in items:
    if 'w' in item:
        acc_num=acc_num+1
print(acc_num)

#count the words that have either an a or an e (don’t double count)
num_a_or_e=0
words=sentence.split()
for word in words:
    if 'a' in word:
        num_a_or_e=num_a_or_e+1
    elif 'e' in word:
        num_a_or_e=num_a_or_e+1
print(num_a_or_e)

#get the total number of vowels in a sentence (5 vowels stored in "vowels")
num_vowels=0
for word in s:
    if vowels[0] in word:
        num_vowels=num_vowels+1
    if vowels[1] in word:
        num_vowels=num_vowels+1
    if vowels[2] in word:
        num_vowels=num_vowels+1
    if vowels[3] in word:
        num_vowels=num_vowels+1
    if vowels[4] in word:
        num_vowels=num_vowels+1
print(num_vowels)

#while loop
def sumTo(aBound):
    """ Return the sum of 1+2+3 ... n """
    theSum  = 0
    aNumber = 1
    while aNumber <= aBound:
        theSum = theSum + aNumber
        aNumber = aNumber + 1
    return theSum

#while loop that is initialized at 0 and stops at 15. If the counter is an even number, append the counter to a list 
eve_nums=[]
count=0
while count <=15:
    if count %2 == 0:
        eve_nums.append(count)
    count=count+1

#while loop to sum all the elements in list1
idx=0 #prep the count of the numbers in the list
accum=0 #prep the sum
while idx<len(list1):
	accum=accum+list1[idx]
	idx=idx+1

#write out the numbers in list until you reach the number 5
def sublist(list):
    mylist  = []
    idx = 0
    while list[idx]!=5:
        mylist.append(int(list[idx]))
        idx = idx + 1
        if idx >= len(list):
            break
    return mylist

#use map to add Fruit: to the beginning of each entry in the list lst_check
map_testing = map((lambda value: 'Fruit: '+value), lst_check)

#use filter to only extract countries in a list called countries that start with B
b_countries= filter(lambda country: 'B' in country, countries)

#use list comprehension to create a new list (lst2) where each value from the original list (lst) is doubled
lst2= [value * 2 for value in lst]

#use list comprehension to list the students in the list students who received a grade>=70
passed= [value[0] for value in students if value[1] >=70]


#zip two lists of equal lengths together
pop_info =list(zip(species, population))
#from that list create a new list only of species with population<2500
endangered=[]
for entry in pop_info:
    if entry[1]<2500:
        endangered.append(entry[0])

#create classes; here create a class called Apple Basket which takes a string for colour and an integer for quantity
class AppleBasket:
    
    def __init__(self, apple_color, apple_quantity):
        self.apple_color = apple_color
        self.apple_quantity = apple_quantity
        
    def increase(self):
        self.apple_quantity=self.apple_quantity + 1
    
    def __str__(self):
        return 'A basket of {} {} apples.'.format(self.apple_quantity, self.apple_color)
    
a = AppleBasket('green', 17)
