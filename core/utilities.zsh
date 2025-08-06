# SmartZSH Timestamp Utility
sz_timestamp() {
  # Use perl for cross-platform millisecond timestamps
  perl -MTime::HiRes=time -e 'print int(time()*1000)'
}
