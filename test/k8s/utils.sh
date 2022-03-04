rpt() {
  CMD=$(fc -ln | tail -2 | head -1)
  echo "repeating until success: $CMD"
  until $CMD
  do
    sleep 1
  done
}