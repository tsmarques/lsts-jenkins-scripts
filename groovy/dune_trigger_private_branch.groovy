def sout = new StringBuilder(), serr = new StringBuilder()

// branches
def proc = 'git -C /home/lsts/jenkins/repositories/dune/private branch -a'.execute() | 'grep -v remotes/origin/HEAD'.execute() | 'grep -v ^*'.execute() | 'cut -c3-'.execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(1000)

def lines = sout.tokenize('\n')

def branches = []
lines.each { line ->
    branches << line.split("remotes/origin/")[1]
    }

// tags
proc = 'git -C /home/lsts/jenkins/repositories/dune/private tag'.execute()
proc.consumeProcessOutput(sout, serr)
proc.waitForOrKill(1000)

branches.addAll(sout.tokenize('\n'))
branches.sort()

// put master branch on top
branches.remove('master')
branches.add(0, 'master')

branches