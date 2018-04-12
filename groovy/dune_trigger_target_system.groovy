def systems = []

systems << 'x86'

new File( '/home/lsts/jenkins/systems.props' ).eachLine { line ->
   // sanitize system name
      // from "lctr-a6xx/lauv-noptilus-1" obtain
         // just "a6xx", or from "lauv-aux-rpi/lauv-xplore-1-aux"
	    // obtain "auxrpi"
	        def tmp = line.tokenize( '/' )[0]
		    system = tmp.substring(tmp.indexOf('-') + 1)
		        system = system.replace('-', '')

    // add sanitized string into list
        systems << system
	}

systems.unique()