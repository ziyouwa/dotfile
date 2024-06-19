BLUE='%F{blue}'
RED='%F{red}'
GREEN='%F{green}'
BLANK='%f'
gitUpstreamPosition() {
    local commitCount=$(git rev-list --count --left-right @{upstream}...HEAD 2> /dev/null)
    if [ -n "$commitCount" ]; then
       local behindCount=$(echo -n "$commitCount" | cut -f1)
       local aheadCount=$(echo -n "$commitCount" | cut -f2)
       if [ "$behindCount" != "0" ]; then
           echo -n " ${behindCount}↓"
       fi
       if [ "$aheadCount" != "0" ]; then
          echo -n " ${aheadCount}↑"
       fi
    fi
}
gitStatusSymbols() {
    local gitstatus=$(git status --porcelain 2> /dev/null)
    if [ -n "$gitstatus" ]; then
		 local addcnt=""
		 local modifiedcnt=""
		 local untrackedcnt="";
         local addedFiles=$(echo "$gitstatus" | grep '^[^? ]' | wc -l)
         local modifiedFiles=$(echo "$gitstatus" | grep '^.[^? ]' | wc -l)
         local untrackedFiles=$(echo "$gitstatus" | grep '^[?][?]' | wc -l)
         if [ "$addedFiles" -gt 0 ]; then
                addcnt=" ✓ : $statusString$GREEN$addedFiles$BLANK"
         fi
         if [ "$modifiedFiles" -gt 0 ]; then
                modifiedcnt=" 🖋️ : $statusString$RED$modifiedFiles$BLANK"
         fi
         if [ "$untrackedFiles" -gt 0 ]; then
                untrackedcnt=" ➕ : $statusString$untrackedFiles"
         fi
         echo -e "$addcnt$modifiedcnt$untrackedcnt"
    fi
}
gitPrompt() {
    local branchName=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
    if [ -n "$branchName" ]; then
      echo -e " [( 🌿 : $BLUE${branchName}$BLANK ) $(gitStatusSymbols) $(gitUpstreamPosition)]"
    fi
}

setopt PROMPT_SUBST
