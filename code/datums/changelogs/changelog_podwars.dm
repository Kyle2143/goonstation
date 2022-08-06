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
	html = changelog_parse(file2text("strings/pod_wars_changelog.txt"), "Pod Wars Changelog")


//Show the pod_wars changelog
/client/proc/pod_wars_changes()
	set category = "Commands"
	set name = "Pod Wars Changelog"
	set desc = "Show or hide the pod wars changelog"

	if (winget(src, "pw_changes", "is-visible") == "true")
		src.Browse(null, "window=pw_changes")

	else
		//in case someone wants to look at it when the map isn't pod_wars
		if (isnull(pod_wars_changelog))
			pod_wars_changelog = new /datum/pod_wars_changelog()

		if (istype(pod_wars_changelog, /datum/pod_wars_changelog))
			var/datum/pod_wars_changelog/changer = pod_wars_changelog
			var/changelogHtml = grabResource("html/changelog.html")	//This is actually just css in a style tag
			var/data = changer.html
			changelogHtml = replacetext(changelogHtml, "<!-- HTML GOES HERE -->", "[data]")
			src.Browse(changelogHtml, "window=pw_changes;size=500x650;title=Pod+Wars+Changelog;", 1)

