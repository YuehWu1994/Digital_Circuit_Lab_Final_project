from PIL import Image

print '#### Generating index_bg.mif... ####'

im = Image.open("qq2.bmp") #Can be many different formats.
pix = im.load()

output_file_index = open('index_qq.mif', 'w')
output_file_index.write('WIDTH = 24;\n')
output_file_index.write('DEPTH = 256;\n\n')
output_file_index.write('ADDRESS_RADIX = HEX;\n')
output_file_index.write('DATA_RADIX = HEX;\n\n')
output_file_index.write('CONTENT BEGIN\n')

idx_to_rgb = dict()
i = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        #print hex(pix[x,y][2]), hex(pix[x,y][1]), hex(pix[x,y][0])
        r = hex(pix[x,y][0])[2:]
        if len(r) == 1:
            r = '0' + r
        g = hex(pix[x,y][1])[2:]
        if len(g) == 1:
            g = '0' + g
        b = hex(pix[x,y][2])[2:]
        if len(b) == 1:
            b = '0' + b
        if( (i < 256) and ((r+g+b) not in idx_to_rgb)):
        	idx_to_rgb[r+g+b] = i
        	output_file_index.write(hex(i)[2:]+':'+b+g+r+';\n')
        	i = i+1
        	#print str(x), ' ', str(y)

print str(i+1), ' colors used.'

while(i<256):
	output_file_index.write(hex(i)[2:]+':'+'000000'+';\n')
	i = i+1

output_file_index.write('END;\n')

print '## index_qq.mif generated. #########'


print '## Generating img_data_qq.mif... ###'

output_file_data = open('img_data_qq.mif', 'w')
output_file_data.write('WIDTH = 8;\n')
output_file_data.write('DEPTH = 307200;\n\n')
output_file_data.write('ADDRESS_RADIX = HEX;\n')
output_file_data.write('DATA_RADIX = HEX;\n\n')
output_file_data.write('CONTENT BEGIN\n')

i = 0
for y in range(im.size[1]):
    for x in range(im.size[0]):
        #print hex(pix[x,y][2]), hex(pix[x,y][1]), hex(pix[x,y][0])
        r = hex(pix[x,y][0])[2:]
        if len(r) == 1:
            r = '0' + r
        g = hex(pix[x,y][1])[2:]
        if len(g) == 1:
            g = '0' + g
        b = hex(pix[x,y][2])[2:]
        if len(b) == 1:
            b = '0' + b
        #print b, g, r
        output_file_data.write(hex(i)[2:]+':'+hex(idx_to_rgb[r+g+b])[2:]+';\n')
        #print str(i+1)
        i = i + 1
    
output_file_data.write('END;\n')

print '############ Finished! #############'
