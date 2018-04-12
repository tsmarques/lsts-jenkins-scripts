def sout = new StringBuilder(), serr = new StringBuilder()
def proc = 'git -C /home/lsts/jenkins/repositories/glued branch -a'.execute() | 'grep -v remotes/origin/HEAD'.execute() | 'grep -v ^*'.execute() | 'cut -c3-'.execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(1000)

//def branches = sout.tokenize('\n')

// put master branch on top
//branches.remove('remotes/origin/master')
//branches.add(0, 'remotes/origin/master')

// tags
proc = 'git -C /home/lsts/jenkins/repositories/dune tag'.execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(1000)


def lines = sout.tokenize('\n')
def branches = []
lines.each { line ->
    if(line.contains("remotes/origin/"))
            branches << line.split("remotes/origin/")[1]
	        else
		        branches << line
			}

branches.sort()

// put master branch on top
branches.remove('master')
branches.add(0, 'master')

branches