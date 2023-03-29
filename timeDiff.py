from datetime import datetime

def TimeDiff(end_time):
    current_time = datetime.now().strftime("%H:%M:%S")
    t1 = datetime.strptime(end_time, "%H:%M:%S")
    t2 = datetime.strptime(current_time, "%H:%M:%S")
    time_diff = t2 - t1
    if time_diff.total_seconds() >= 1:
        return True
    else:
        return False
    
print(TimeDiff("15:04:00"))
