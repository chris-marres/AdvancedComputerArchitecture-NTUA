import sys
import numpy as np

## We need matplotlib:
## $ apt-get install python-matplotlib
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt

x_Axis = []
ipc_Axis = []
mpki_Axis = []

tlb_entries_base = 8.0
tlb_assoc_base = 4.0
simname = sys.argv[2]

for outFile in sys.argv[3:]:
	fp = open(outFile)
	line = fp.readline()
	while line:
		tokens = line.split()
		if (line.startswith("Total Instructions: ")):
			total_instructions = int(tokens[2])
		elif (line.startswith("IPC:")):
			ipc = float(tokens[1])
		elif (line.startswith("  Data Tlb")):
			sizeLine = fp.readline()
			tlb_entries  = sizeLine.split()[1]
			bsizeLine = fp.readline()
			tlb_psize  = bsizeLine.split()[2]
			assocLine = fp.readline()
			tlb_assoc  = assocLine.split()[1]
		elif (line.startswith("Tlb-Total-Misses")):
			tlb_total_misses  = int(tokens[1])
			tlb_miss_rate  = float(tokens[2].split('%')[0])
			mpki = tlb_total_misses  / (total_instructions / 1000.0)


		line = fp.readline()

	fp.close()

	if sys.argv[1] == "true":
		size_reduction = float(np.log2(float(tlb_entries ) / tlb_entries_base))
		while (size_reduction > 0.0):
			ipc *= 0.85
			size_reduction =- 1.0

		assoc_reduction = float(np.log2(float(tlb_assoc ) / tlb_assoc_base))
		while (assoc_reduction > 0.0):
			ipc *= 0.90
			assoc_reduction -= 1.0

	l1ConfigStr = '{}K.{}.{}B'.format(int(tlb_entries),int(tlb_assoc),int(tlb_psize))
	print(l1ConfigStr)
	x_Axis.append(l1ConfigStr)
	ipc_Axis.append(ipc)
	mpki_Axis.append(mpki)

print(x_Axis)
print(ipc_Axis)
print(mpki_Axis)

fig, ax1 = plt.subplots()
ax1.grid(True)
ax1.set_xlabel("TLB Size.Associativity.Page Size")

xAx = np.arange(len(x_Axis))
ax1.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax1.set_xticklabels(x_Axis, rotation=45)
ax1.set_xlim(-0.5, len(x_Axis) - 0.5)
ax1.set_ylim(min(ipc_Axis) - 0.05 * min(ipc_Axis), max(ipc_Axis) + 0.05 * max(ipc_Axis))
ax1.set_ylabel("$IPC$")
line1 = ax1.plot(ipc_Axis, label="ipc", color="red",marker='x')

ax2 = ax1.twinx()
ax2.xaxis.set_ticks(np.arange(0, len(x_Axis), 1))
ax2.set_xticklabels(x_Axis, rotation=45)
ax2.set_xlim(-0.5, len(x_Axis) - 0.5)
ax2.set_ylim(min(mpki_Axis) - 0.05 * min(mpki_Axis), max(mpki_Axis) + 0.05 * max(mpki_Axis))
ax2.set_ylabel("$MPKI$")
line2 = ax2.plot(mpki_Axis, label="L1D_mpki", color="green",marker='o')

lns = line1 + line2
labs = [l.get_label() for l in lns]

plt.title(simname)
plt.suptitle("IPC vs MPKI")
lgd = plt.legend(lns, labs)
lgd.draw_frame(False)
if sys.argv[1] == "false":
	plt.savefig('TLB_{}.png'.format(simname), bbox_inches='tight')
elif sys.argv[1] == "true":
	plt.savefig('TLB_{}_reduced.png'.format(simname), bbox_inches='tight')
