  $ export TESTTMP=${PWD}

  $ cd ${TESTTMP}
  $ git init -q testrepo 1> /dev/null
  $ cd testrepo

  $ mkdir sub1
  $ printf "First Test document" > sub1/file1
  $ git add sub1
  $ git commit -m "add file1" 1> /dev/null

  $ printf "Another document with more \n than \n one line" > sub1/file2
  $ git add sub1
  $ git commit -m "add file2" 1> /dev/null

  $ mkdir sub2
  $ printf "One more to see what happens" > sub2/file3
  $ git add sub2
  $ git commit -m "add file3" 1> /dev/null

  $ josh-filter -s :INDEX --update refs/heads/index
  [3] :INDEX
  [6] _trigram_index

  $ josh-filter :/ --search "Another"
  sub1/file2:1: Another document with more 
  $ josh-filter :/ --search "happens"
  sub2/file3:1: One more to see what happens
  $ josh-filter :/ --search "Test"
  sub1/file1:1: First Test document
  $ josh-filter :/ --search "document"
  sub1/file1:1: First Test document
  sub1/file2:1: Another document with more 
  $ josh-filter :/ --search "x"
  $ josh-filter :/ --search "e"
  sub1/file1:1: First Test document
  sub1/file2:1: Another document with more 
  sub1/file2:3:  one line
  sub2/file3:1: One more to see what happens
  $ josh-filter :/ --search "line"
  sub1/file2:3:  one line

  $ josh-filter :/ -g 'query { rev(at: "refs/heads/master") { results: search(string: "e") { path { path }, matches { line, text }} }}'
  {
    "rev": {
      "results": [
        {
          "path": {
            "path": "sub1/file1"
          },
          "matches": [
            {
              "line": 1,
              "text": "First Test document"
            }
          ]
        },
        {
          "path": {
            "path": "sub1/file2"
          },
          "matches": [
            {
              "line": 1,
              "text": "Another document with more "
            },
            {
              "line": 3,
              "text": " one line"
            }
          ]
        },
        {
          "path": {
            "path": "sub2/file3"
          },
          "matches": [
            {
              "line": 1,
              "text": "One more to see what happens"
            }
          ]
        }
      ]
    }
  }

  $ git diff ${EMPTY_TREE}..refs/heads/index
  diff --git a/SUB1 b/SUB1
  new file mode 100644
  index 0000000..095149c
  --- /dev/null
  +++ b/SUB1
  @@ -0,0 +1,4 @@
  +c002000000000010080000000022080000000020210000200048000000000000240004080023000800200884002055080000000210000000400008000000000a
  +0020060802054480a0a80001240001004805000030000000800002000ca004040220228040010000000080000000001040100030100202000003204020202020
  +0000100000000000580000200850081040000000023c01004090020000084200a0000104040122000000000000000008400c204000000880140000c41a540400
  +000004910100600000000000c00060020000808000020610c004800008a0000410000000201208000a8080000810001280001600201810400000010000100000
  \ No newline at end of file
  diff --git a/sub1/BLOBS1 b/sub1/BLOBS1
  new file mode 100644
  index 0000000..1114b0c
  --- /dev/null
  +++ b/sub1/BLOBS1
  @@ -0,0 +1,5 @@
  +file1
  +00000200000100008880800000000000000000023000020000000200000000000000000000000000008000008000000000000000000402004000000000000000 0011
  +
  +file2
  +000206000000008088208080200008080000000020000200000008000400200ca000000004030800020000200810000200002000000002400004010010e00000 002a
  diff --git a/sub1/OWN1 b/sub1/OWN1
  new file mode 100644
  index 0000000..2e96f2e
  --- /dev/null
  +++ b/sub1/OWN1
  @@ -0,0 +1,4 @@
  +c002000000000010080000000022080000000020200000000040000000000000000004000021000800000884002001080000000200000000400008000000000a
  +0020060800054080a0a80001240001000805000020000000000002000ca000040220208040010000000080000000000040100000100202000000204020002020
  +0000000000000000400000200810001000000000021c01004010000000084200a00000040401020000000000000000084008204000000880140000401a540400
  +0000041000002000000000008000600200008000000002004004800008a0000000000000200208000a8080000810001200001400000810400000010000100000
  \ No newline at end of file
  diff --git a/sub2/BLOBS1 b/sub2/BLOBS1
  new file mode 100644
  index 0000000..d93ea49
  --- /dev/null
  +++ b/sub2/BLOBS1
  @@ -0,0 +1,2 @@
  +file3
  +24000008000000000000000400000000400000002100000080020000002020000000100105100000080000000040000240000000200004008004000002800000 001a
  diff --git a/sub2/OWN1 b/sub2/OWN1
  new file mode 100644
  index 0000000..bbd3d20
  --- /dev/null
  +++ b/sub2/OWN1
  @@ -0,0 +1,4 @@
  +80000000000000000000000000000000000000002100002000080000000000002400000800020000002000040000540000000000100000000000000000000000
  +00000000020104008000000000000000480000001000000080000000000004000000020040000000000000000000001000000030000000000003000000202000
  +00001000000000001800000000400800400000000220000000800200000800000000010004002200000000000000000000040000000000000000008402000400
  +00000481010040000000000040000002000000800002041080040000008000041000000000100000000000000000000080001200201000000000000000100000
  \ No newline at end of file
