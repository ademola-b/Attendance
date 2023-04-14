from apscheduler.schedulers.background import BackgroundScheduler
from attendance.views import UpdateAttendanceSlot

def start():
    # get instance of the background scheduler
    scheduler = BackgroundScheduler()
    attendance_slot = UpdateAttendanceSlot()
    # assign a job
    scheduler.add_job(attendance_slot.update_slot, 
                      "interval", minutes = 1, 
                      id = "slot_001", replace_existing=True)
    scheduler.start()