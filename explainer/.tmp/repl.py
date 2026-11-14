import io
base = 'C:/Users/semyo/Documents/GitHub/mighty-math-magicians'
lg = io.open(base + '/explainer/logic.js', encoding='utf-8').read()
new = io.open(base + '/explainer/.tmp/skel_new.js', encoding='utf-8').read()
start = lg.index('// Build one labelled skeleton for the atom multiset')
end = lg.index('// Collect every cherry')
lg = lg[:start] + new + lg[end:]
io.open(base + '/explainer/logic.js', 'w', encoding='utf-8', newline='\n').write(lg)
s = io.open(base + '/explainer/index.html', encoding='utf-8').read()
b = s.index('/* LOGIC-BEGIN */') + len('/* LOGIC-BEGIN */')
e = s.index('/* LOGIC-END */')
s = s[:b] + '\n' + lg.rstrip() + '\n\n' + s[e:]
io.open(base + '/explainer/index.html', 'w', encoding='utf-8', newline='\n').write(s)
print('ok')
