#!/c/Python32/python.exe
import sys
import os
import os.path
import xml.etree.ElementTree as ET

ns = '{http://schemas.microsoft.com/developer/msbuild/2003}'

print("-------start to search")
#Works with relative path also
projectFileName = sys.argv[1]

if not os.path.isabs(projectFileName):
   projectFileName = os.path.join(os.getcwd(), projectFileName) 

filterTree = ET.parse(projectFileName+".filters")
filterRoot = filterTree.getroot()
filterDict = dict()
missingDict = dict()

for inc in filterRoot.iter(ns+'ClInclude'):
    incFileRel = inc.get('Include')
    incFilter = inc.find(ns+'Filter')
    if incFileRel != None and incFilter != None:
        filterDict[incFileRel] = incFilter.text
        if incFilter.text not in missingDict:
            missingDict[incFilter.text] = []

projTree = ET.parse(projectFileName)
projRoot = projTree.getroot()

for inc in projRoot.iter(ns+'ClInclude'):
    incFileRel = inc.get('Include')
    if incFileRel != None:
        incFile = os.path.abspath(os.path.join(os.path.dirname(projectFileName), incFileRel))
        if not os.path.exists(incFile):
            missingDict[filterDict[incFileRel]].append(incFileRel)

for (missingGroup, missingList) in missingDict.items():
    if len(missingList) > 0:
        print("["+missingGroup+"]:")
        for missing in missingList:
            print("  " + os.path.basename(missing) + "   (" + missing + ")")