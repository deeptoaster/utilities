#!/usr/bin/python
import json
import random
import urllib2
from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont

column1 = ['Fuck off', 'Piss off', 'Get in the sea', 'Tie your dick to a tractor', 'Step on an upturned plug', 'I\'d like to back over you with a tractor', 'Your face looks like spoiled gammon', 'I hope you shit yourself to death', 'Bite a pylon', 'Kindly die', 'Have you not fucked off yet', 'Suck an exhaust pipe', 'Cycle 100 miles underwater with no oxygen supply', 'Die in a bin fire', 'Step on a Lego brick']
column1 += ['You did an absolutely horrible job', 'You should be ashamed of yourself', 'All you do is talk', 'You never had a chance', 'You have zero cred', 'Love watching you fail', 'What a dope', 'You need a new pair of glasses', 'You graduated last in your class', 'You\'ve got a lot of problems', 'No imagination', 'You are dumb as a rock', ]
column2 = ['you appalling', 'you deluded', 'you glistening', 'you deplorable', 'you absurd', 'you utter', 'you contemptible', 'you horrendous', 'you lizardy', 'you hopeless', 'you unacceptable']
column2 += ['you boring', 'you irrelevant', 'you terrible', 'you desperate', 'you total', 'you strictly']
column3 = ['prick-faced', 'ham-faced', 'toss-faced', 'idiot', 'cunt-faced', 'spinogelatinous', 'flubber-faced', 'fraudulent', 'plum-faced', 'spoon-faced', 'dish-faced', 'cock-nosed', 'shapeshifting']
column3 += ['liberal', 'hokey', 'goofball', 'highly-overrated', 'uncomfortable-looking', 'third-rate']
column4 = ['twunt', 'spunktrumpet', 'fucktard', 'bastard', 'cockwomble', 'shitweasel', 'robot made of gammon', 'thundercunt', 'ponce', 'cock', 'moontwat', 'cockweasel', 'pissweasel', 'wankspangle', 'vomitpustule', 'quimwiffle', 'wankstain', 'spunkrocket', 'wanksack doused in piss', 'dicksplash', 'Etonian reptile', 'cocksplurt', 'cut-price Goebbels']
column4 += ['clown', 'garbage', 'atheist', 'guy', 'dummy', 'dope', 'hypocrite', 'lightweight', 'loser']
req = urllib2.Request('https://www.reddit.com/r/EarthPorn/.json')
req.add_header('User-Agent', 'Paperbot/2.0')
porns = json.load(urllib2.urlopen(req))['data']['children']
insult = random.choice(column1).split() + random.choice(column2).split() + random.choice(column3).split() + random.choice(column4).split()
for porn in porns:
	url = porn['data']['url']
	if not url.endswith(('.gif', '.jpeg', '.jpg', '.png', '.tif', '.tiff')):
		if 'imgur.com' in url:
			url = url + '.jpg'
		else:
			continue
	img = Image.open(urllib2.urlopen(url))
	w, h = img.size
	size = w / 50
	font = ImageFont.truetype("/usr/share/fonts/truetype/freefont/FreeSans.ttf", size)
	draw = ImageDraw.Draw(img)
	draw.text((w * 0.3, h * 0.3), ' '.join(insult[:len(insult) / 2 + 2]), font=font)
	draw.text((w * 0.3, h * 0.3 + size * 1.5), ' '.join(insult[len(insult) / 2 + 2:]), font=font)
	img.crop((0, 0, int(w * 0.8), int(h * 0.8))).save('/home/woot/Documents/backdrops/haut-gauche', 'PNG')
	img.crop((int(w * 0.2), 0, w, int(h * 0.8))).save('/home/woot/Documents/backdrops/haut-droite', 'PNG')
	img.crop((0, int(h * 0.2), int(w * 0.8), h)).save('/home/woot/Documents/backdrops/bas-gauche', 'PNG')
	img.crop((int(w * 0.2), int(h * 0.2), w, h)).save('/home/woot/Documents/backdrops/bas-droite', 'PNG')
	break
