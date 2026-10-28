//Begin Step: inject the simulated keys before oPlayer reads them
if (task >= array_length(tasks)) exit;
var _f = method(self, tasks[task]);
if (_f())
{
	task++;
	tt = 0;
	mem = {};
}
else tt++;
