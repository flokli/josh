  $ source ${TESTDIR}/setup_test_env.sh
  $ cd ${TESTTMP}


  $ git clone -q http://${TESTUSER}:${TESTPASS}@localhost:8001/real_repo.git
  warning: You appear to have cloned an empty repository.

  $ curl -s http://localhost:8002/version
  Version: * (glob)

  $ cd real_repo

  $ git status
  On branch master
  
  No commits yet
  
  nothing to commit (create/copy files and use "git add" to track)

  $ mkdir -p sub1/subsub
  $ echo contents1 > sub1/subsub/file1
  $ git add .
  $ git commit -m "add file1"
  [master (root-commit) *] add file1 (glob)
   1 file changed, 1 insertion(+)
   create mode 100644 sub1/subsub/file1

  $ mkdir sub2
  $ echo contents1 > sub2/file2
  $ git add sub2
  $ git commit -m "add file2" &> /dev/null

  $ git log --graph --pretty=%s
  * add file2
  * add file1

  $ git push
  To http://localhost:8001/real_repo.git
   * [new branch]      master -> master

  $ cd ${TESTTMP}
  $ cat > viewfile <<EOF
  > real_repo.git
  > / : !empty/empty
  > a/b : !/sub2
  > c : !/sub1
  > EOF
  $ X=$(curl -s http://localhost:8002/view --upload-file viewfile)
  $ git clone -q http://${TESTUSER}:${TESTPASS}@localhost:8002/view/${X}/ stored
  $ cd stored
  $ tree
  .
  |-- a
  |   `-- b
  |       `-- file2
  `-- c
      `-- subsub
          `-- file1
  
  4 directories, 2 files

  $ git log --graph --pretty=%s
  * add file2
  * add file1

  $ git checkout HEAD~1 &> /dev/null

  $ tree
  .
  `-- c
      `-- subsub
          `-- file1
  
  2 directories, 1 file

  $ bash ${TESTDIR}/destroy_test_env.sh
