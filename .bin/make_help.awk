# grouped help for makefiles
#   ##@ Group      - following targets are listed under "Group"
#                    groups are shown in the order they first appear
#   target: ## ... - target description
#   ## ...         - lines right after a target extend its description
# targets in "Bundles" also list what they install on the current os (-v os=...)
# targets also list their "x/<name>" variants registered via "x:: x/<name>"

function row(name, text) { return sprintf("  \033[36m%-15s\033[0m %s\n", name, text) }
function dim(text) { return "\033[2m" text "\033[0m" }

BEGIN { skip = os == "Darwin" ? "^(pacman|yay)/" : "^(brew|cask)/" }

/^##@ / {
    group = substr($0, 5)
    if (!(group in targets)) { targets[group] = ""; groups[++n] = group }
    next
}

/^[^#\t ]+:+ +## / {
    split($0, part, /:+ +## /)
    target = part[1]
    targets[group] = targets[group] " " target
    bundle[target] = group == "Bundles"
    help[target] = row(target, part[2])
    next
}

/^## / { help[target] = help[target] row("", dim(substr($0, 4))); next }

# prerequisites of a bundle, e.g. "minimal: brew/fd pacman/fd # comment"
{ name = $1; sub(/:+$/, "", name) }
$1 ~ /:$/ && bundle[name] {
    for (i = 2; i <= NF && $i !~ /^#/; i++) {
        if ($i ~ skip || seen[name, $i]++) continue
        sub(/^(mise\/npm|[a-z]+)\//, "", $i)
        if (length(line[name]) + length($i) > 60) { help[name] = help[name] row("", dim(line[name])); line[name] = "" }
        line[name] = line[name] (line[name] == "" ? "" : " ") $i
    }
}

# variants of a documented target, e.g. "upgrade:: $(call unskipped,upgrade/brew)"
$1 ~ /:$/ && !bundle[name] && name in help {
    gsub(/\$\(call unskipped,|\)/, "")
    for (i = 2; i <= NF && $i !~ /^#/; i++) {
        if (index($i, name "/") != 1 || $i in variant) continue
        variant[$i] = name
        if ((substr($i, length(name) + 2) "/") !~ skip) variants[name] = variants[name] " " $i
    }
}

END {
    print "Usage: make -f .Makefile \033[36m<target>\033[0m ..."
    for (g = 1; g <= n; g++) {
        if (!split(targets[groups[g]], names, " ")) continue
        printf "\n\033[1m%s\033[0m\n", groups[g]
        for (i = 1; names[i] != ""; i++) {
            # documented variants are listed under their parent instead
            if (names[i] in variant) continue
            printf "%s", help[names[i]]
            if (line[names[i]] != "") printf "%s", row("", dim(line[names[i]]))
            split(variants[names[i]], vs, " ")
            for (j = 1; vs[j] != ""; j++) printf "%s", vs[j] in help ? help[vs[j]] : row(vs[j], "")
            delete vs
        }
    }
}
