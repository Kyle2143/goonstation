/*I'm sorry about this, but I'm not int he mood to rewrite this dumb system, and apparently neither was wire when he made the
admin changelog. So I just basically did the same. These changelogs should all be encapsulated in a datum/changelog 
type. But instead we have this. A datum that is basically just a string and the actual processing of the changelog stuff done outside the datum...
Sincerely yours, 
Kyle
*/

/datum/pod_wars_changelog
	var/html = null

/* ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

ATTENTION: The changelog has moved into its own file: strings/admin_changelog.txt

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/

/datum/pod_wars_changelog/New()
	..()
	//Changelog has moved to its own file.
	//Note: deliberately using double quotes so that it won't be included in the RSC -SpyGuy
	html = changelog_parse(file2text("strings/pod_wars_changelog.txt"), "Admin Changelog")


//Show the pod_wars changelog
/client/proc/changes_pod_wars()
	if (winget(src, "changes", "is-visible") == "true")
		src.Browse(null, "window=changes")
	else
		var/changelogHtml = grabResource("html/changelog.html")
		//in case someone wants to look at it when the map isn't pod_wars
		if (isnull(pod_wars_changelog))
			pod_wars_changelog = new /datum/pod_wars_changelog()

		var/data = pod_wars_changelog:html
		changelogHtml = replacetext(changelogHtml, "<!-- HTML GOES HERE -->", "[data]")
		src.Browse(changelogHtml, "window=adminchanges;size=500x650;title=Pod+Wars+Changelog;", 1)
