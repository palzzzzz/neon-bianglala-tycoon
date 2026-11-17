local Runtime={context=nil}
function Runtime.wait()
	while not Runtime.context do task.wait() end
	return Runtime.context
end
return Runtime
