using Test
using BulletsMaggots

@test bm_count(1111, 2222) == (0, 0)
@test bm_count(1111, 1234) == (1, 0)
@test bm_count(1234, 4321) == (0, 4)
@test bm_solver(5678, false) > 0
