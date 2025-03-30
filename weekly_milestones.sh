#!/bin/bash

# === CONFIGURATION ===
REPOS=("your-username/gnc_core" "your-username/gnc_sim")
MILESTONE_TITLE="Week $(date +%V): $(date +'%b %d')" # Example: Week 14: Apr 01
DUE_DATE=$(date -v+5d +%Y-%m-%d)  # 5 days from now (for weekly)
CARRY_FROM="Week $(($(date +%V)-1))"

# === CREATE NEW MILESTONE IN EACH REPO ===
for REPO in "${REPOS[@]}"; do
  echo "📌 Creating milestone in $REPO..."
  gh api -X POST repos/"$REPO"/milestones \
    -f title="$MILESTONE_TITLE" \
    -f due_on="$DUE_DATE" \
    -f state="open"
done

# === OPTIONAL: Carry Over Open Issues from Last Week ===
echo "🔄 Carrying over open issues from milestone: $CARRY_FROM"

for REPO in "${REPOS[@]}"; do
  echo "⏳ Checking $REPO..."
  ISSUE_NUMS=$(gh issue list -R "$REPO" --milestone "$CARRY_FROM" --state open --json number -q '.[].number')
  
  for ISSUE in $ISSUE_NUMS; do
    echo "🔁 Moving issue #$ISSUE in $REPO to $MILESTONE_TITLE"
    gh issue edit "$ISSUE" -R "$REPO" --milestone "$MILESTONE_TITLE"
  done
done

# === Optional: Create Local Weekly Log Template ===
LOG_FILE="week-$(date +%V)-log.md"
cat > $LOG_FILE <<EOF
# 📅 Week $(date +%V) Log – $(date +'%b %d, %Y')

## ✅ Goals for the Week
- [ ] 

## 🔄 Carry-Overs from Last Week
- [ ] 

## 🧠 Reflections
- What worked well?
- What slowed you down?
- What are you excited about?

EOF

echo "📝 Created local log: $LOG_FILE"
