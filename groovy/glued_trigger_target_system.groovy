def systems = []
new File( '/home/lsts/jenkins/systems.props' ).eachLine { line ->
    systems << line
    }

systems