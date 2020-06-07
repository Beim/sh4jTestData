#!/bin/sh

for i in `ls -d [0-9][0-9][0-9]`
do
echo $i
ed -s $i/onto.rdf << EOF &>/dev/null
1,$ s;2006/benchmarks;tests;g
w
q
EOF
ed -s $i/refalign.rdf << EOF &>/dev/null
1,$ s;2006/benchmarks;tests;g
w
q
EOF
ed -s $i/onto.html << EOF &>/dev/null
1,$ s;2006/benchmarks;tests;g
w
q
EOF
ed -s $i/refalign.html << EOF &>/dev/null
1,$ s;2006/benchmarks;tests;g
w
q
EOF
done
for i in 206 207 210
do
echo $i
ed -s $i/onto-iso8859.rdf << EOF &>/dev/null
1,$ s;2006/benchmarks;tests;g
w
q
EOF
ed -s $i/refalign-iso8859.rdf << EOF &>/dev/null
1,$ s;2006/benchmarks;tests;g
w
q
EOF
done

for i in `ls -d [0-9][0-9][0-9]`
do
echo $i
ed -s $i/refalign.rdf << EOF &>/dev/null
1,$ s;file://localhost/Volumes/Phata/Web/html/co4/oaei/lib;http://oaei.inrialpes.fr/tests;g
w
q
EOF
ed -s $i/refalign.html << EOF &>/dev/null
1,$ s;file://localhost/Volumes/Phata/Web/html/co4/oaei/lib;http://oaei.inrialpes.fr/tests;g
w
q
EOF
done
for i in 206 207 210
do
ed -s $i/refalign-iso8859.rdf << EOF &>/dev/null
1,$ s;file://localhost/Volumes/Phata/Web/html/co4/oaei/lib;http://oaei.inrialpes.fr/tests;g
w
q
EOF
done
