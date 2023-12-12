#
# ~/.gdbinit
#
# .so を shlib コマンドで手動で読み込む
# set auto-solib-add 0
# スレッド生成時のSIG32でブレークしない
handle SIG32 nostop
# ニモニック構文の選択
 set disassembly-flavor intel
# set disassembly-flavor att
# フラグレジスタの可読化関数
define pf
        printf "eflags: %s%s%s%s%s%s%s%s%s (= 0x%08u)\n",\
                $eflags & 2048 ?  "O":"-",\
                $eflags & 1024 ?  "D":"-",\
                $eflags & 512  ?  "I":"-",\
                $eflags & 256  ?  "T":"-",\
                $eflags & 128  ?  "S":"-",\
                $eflags & 64   ?  "Z":"-",\
                $eflags & 16   ?  "A":"-",\
                $eflags & 4    ?  "P":"-",\
                $eflags & 1    ?  "C":"-",\
                $eflags
end
# stepiしてフラグを表示
define sip
        si
        pf
end
# stepiしてフラグ+レジスタを表示
define sips
        si
        pf
        reg
end
# 次に実行する命令(とその先10命令)のアセンブリリストを出力する
define al
        x/11i $pc
end
# レジスタを表示
define reg
        printf "eax:%08x ebx:%08x ecx:%08x edx:%08x\nedi:%08x esi:%08x ebp:%08x esp:%08x\n", \
                $eax, $ebx, $ecx, $edx, $edi, $esi, $ebp, $esp
end
# すべてのレジスタを表示
define allreg
        reg
        printf  "CS:%04x DS:%04x SS:%04x ES:%04x FS:%04x GS:%04x EIP:%08x", \
                $cs, $ds, $ss, $es, $fs, $gs, $eip
        printf "\n"
        pf
        printf "\ncurrent instruction:\n "
        x/1i $pc
end
define myinit
        source ~/gdbcom
end

set print pretty on

# Source all settings from the peda dir
#source ~/peda/peda.py
 
# These are other settings I have found useful
# When inspecting large portions of code the scrollbar works better than 'less'
set pagination off
 
 
# Keep a history of all the commands typed. Search is possible using ctrl-r
set history save on
set history filename ~/.gdb_history
set history size 32768
set history expansion on

#layout asm
#layout regs

