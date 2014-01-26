
# 2 step process: filter full text, then run TEES
# get text filter extraction data
# relations copied from http://www2.bio.ifi.lmu.de/publications/RelEx/ into relex.txt
# authors are extracted from /hive/data/inside/pubs/text/medline
zcat medline/*.articles.gz | cut -f13 | tail -n+2 | sort | uniq > authors.txt
pickleExtractionData -r relex.txt -a authors.txt -o extractionData.pkl

# run filtering script, requires geneFinder.py
# optionally can include pubGeneric.py to remove references - it's not working for me though so I commented it out in the script
interactionFinder.py data/*.files.gz
#Text-PPI-Filter data/*.files.gz 

# step 2: run TEES
classify.py -i sentences.txt -m GE11-test -o tees-output

# once TEES is finished, extract and parse
tar -xvf *-events.tar.gz
# make sure everything is within your directory of choice
ParseTEES -a1 sentences.a1 -a2 sentences.a2 -r sentences.txt -g genes.txt

