; RUN: opt %loadPolly -pass-remarks-missed="polly-detect" -polly-detect-track-failures -polly-detect -analyze < %s 2>&1| FileCheck %s
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; void onlyWrite(float *A) {
;   for (long i = 0; i < 100; i++)
;     A[i] = 0;
; }
; 
; void onlyRead(float *A) {
;   for (long i = 0; i < 100; i++)
;     A[i];
; }

; CHECK: remark: /tmp/test.c:2:3: The following errors keep this region from being a Scop.
; CHECK: remark: /tmp/test.c:2:3: No profitable polyhedral optimization found
; CHECK: remark: /tmp/test.c:3:10: Invalid Scop candidate ends here.

; CHECK: remark: /tmp/test.c:7:3: The following errors keep this region from being a Scop.
; CHECK: remark: /tmp/test.c:7:3: No profitable polyhedral optimization found
; CHECK: remark: /tmp/test.c:8:10: Invalid Scop candidate ends here.


; Function Attrs: nounwind uwtable
define void @onlyWrite(float* %A) #0 {
entry:
  call void @llvm.dbg.value(metadata float* %A, i64 0, metadata !14, metadata !15), !dbg !16
  call void @llvm.dbg.value(metadata i64 0, i64 0, metadata !17, metadata !15), !dbg !20
  br label %for.cond, !dbg !21

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %exitcond = icmp ne i64 %i.0, 100, !dbg !22
  br i1 %exitcond, label %for.body, label %for.end, !dbg !22

for.body:                                         ; preds = %for.cond
  %arrayidx = getelementptr inbounds float, float* %A, i64 %i.0, !dbg !23
  store float 0.000000e+00, float* %arrayidx, align 4, !dbg !25
  br label %for.inc, !dbg !23

for.inc:                                          ; preds = %for.body
  %inc = add nuw nsw i64 %i.0, 1, !dbg !26
  call void @llvm.dbg.value(metadata i64 %inc, i64 0, metadata !17, metadata !15), !dbg !20
  br label %for.cond, !dbg !27

for.end:                                          ; preds = %for.cond
  ret void, !dbg !28
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.declare(metadata, metadata, metadata) #1

; Function Attrs: nounwind uwtable
define void @onlyRead(float* %A) #0 {
entry:
  call void @llvm.dbg.value(metadata float* %A, i64 0, metadata !29, metadata !15), !dbg !30
  call void @llvm.dbg.value(metadata i64 0, i64 0, metadata !31, metadata !15), !dbg !33
  br label %for.cond, !dbg !34

for.cond:                                         ; preds = %for.inc, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %exitcond = icmp ne i64 %i.0, 100, !dbg !35
  br i1 %exitcond, label %for.body, label %for.end, !dbg !35

for.body:                                         ; preds = %for.cond
  %arrayidx = getelementptr inbounds float, float* %A, i64 %i.0, !dbg !36
  %val = load float, float* %arrayidx, align 4, !dbg !38
  br label %for.inc, !dbg !36

for.inc:                                          ; preds = %for.body
  %inc = add nuw nsw i64 %i.0, 1, !dbg !39
  call void @llvm.dbg.value(metadata i64 %inc, i64 0, metadata !31, metadata !15), !dbg !33
  br label %for.cond, !dbg !40

for.end:                                          ; preds = %for.cond
  ret void, !dbg !41
}

; Function Attrs: nounwind readnone
declare void @llvm.dbg.value(metadata, i64, metadata, metadata) #1

attributes #0 = { nounwind uwtable "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { nounwind readnone }

!llvm.dbg.cu = !{!0}
!llvm.module.flags = !{!11, !12}
!llvm.ident = !{!13}

!0 = !MDCompileUnit(language: DW_LANG_C99, producer: "clang version 3.7.0  (llvm/trunk 229257)", isOptimized: false, emissionKind: 1, file: !1, enums: !2, retainedTypes: !2, subprograms: !3, globals: !2, imports: !2)
!1 = !MDFile(filename: "/tmp/test.c", directory: "/home/grosser/Projects/polly/git/tools/polly")
!2 = !{}
!3 = !{!4, !10}
!4 = !MDSubprogram(name: "onlyWrite", line: 1, isLocal: false, isDefinition: true, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 1, file: !1, scope: !5, type: !6, function: void (float*)* @onlyWrite, variables: !2)
!5 = !MDFile(filename: "/tmp/test.c", directory: "/home/grosser/Projects/polly/git/tools/polly")
!6 = !MDSubroutineType(types: !7)
!7 = !{null, !8}
!8 = !MDDerivedType(tag: DW_TAG_pointer_type, size: 64, align: 64, baseType: !9)
!9 = !MDBasicType(tag: DW_TAG_base_type, name: "float", size: 32, align: 32, encoding: DW_ATE_float)
!10 = !MDSubprogram(name: "onlyRead", line: 6, isLocal: false, isDefinition: true, flags: DIFlagPrototyped, isOptimized: false, scopeLine: 6, file: !1, scope: !5, type: !6, function: void (float*)* @onlyRead, variables: !2)
!11 = !{i32 2, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{!"clang version 3.7.0  (llvm/trunk 229257)"}
!14 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "A", line: 1, arg: 1, scope: !4, file: !5, type: !8)
!15 = !MDExpression()
!16 = !MDLocation(line: 1, column: 23, scope: !4)
!17 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "i", line: 2, scope: !18, file: !5, type: !19)
!18 = distinct !MDLexicalBlock(line: 2, column: 3, file: !1, scope: !4)
!19 = !MDBasicType(tag: DW_TAG_base_type, name: "long int", size: 64, align: 64, encoding: DW_ATE_signed)
!20 = !MDLocation(line: 2, column: 13, scope: !18)
!21 = !MDLocation(line: 2, column: 8, scope: !18)
!22 = !MDLocation(line: 2, column: 3, scope: !18)
!23 = !MDLocation(line: 3, column: 5, scope: !24)
!24 = distinct !MDLexicalBlock(line: 2, column: 3, file: !1, scope: !18)
!25 = !MDLocation(line: 3, column: 10, scope: !24)
!26 = !MDLocation(line: 2, column: 30, scope: !24)
!27 = !MDLocation(line: 2, column: 3, scope: !24)
!28 = !MDLocation(line: 4, column: 1, scope: !4)
!29 = !MDLocalVariable(tag: DW_TAG_arg_variable, name: "A", line: 6, arg: 1, scope: !10, file: !5, type: !8)
!30 = !MDLocation(line: 6, column: 22, scope: !10)
!31 = !MDLocalVariable(tag: DW_TAG_auto_variable, name: "i", line: 7, scope: !32, file: !5, type: !19)
!32 = distinct !MDLexicalBlock(line: 7, column: 3, file: !1, scope: !10)
!33 = !MDLocation(line: 7, column: 13, scope: !32)
!34 = !MDLocation(line: 7, column: 8, scope: !32)
!35 = !MDLocation(line: 7, column: 3, scope: !32)
!36 = !MDLocation(line: 8, column: 5, scope: !37)
!37 = distinct !MDLexicalBlock(line: 7, column: 3, file: !1, scope: !32)
!38 = !MDLocation(line: 8, column: 10, scope: !37)
!39 = !MDLocation(line: 7, column: 30, scope: !37)
!40 = !MDLocation(line: 7, column: 3, scope: !37)
!41 = !MDLocation(line: 9, column: 1, scope: !10)
