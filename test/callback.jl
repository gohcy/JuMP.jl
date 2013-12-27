if Pkg.installed("Gurobi") != nothing  
    using Gurobi

    let
        mod = Model(solver=GurobiSolver(LazyConstraints=1))

        @defVar(mod, 0 <= x <= 2, Int)
        @defVar(mod, 0 <= y <= 2, Int)
        @setObjective(mod, Max, y + 0.5x)
        function corners(cb)
            x_val = getValue(x)
            y_val = getValue(y)
            TOL = 1e-6
            # Check top right
            if y_val + x_val > 3 + TOL
                @addLazyConstraint(cb, y + x <= 3)
            end
        end
        setlazycallback(mod, corners)
        solve(mod)
        @test_approx_eq_eps getValue(x) 1.0 1e-6
        @test_approx_eq_eps getValue(y) 2.0 1e-6
    end
    let
        mod = Model(solver=GurobiSolver(PreCrush=1, Cuts=0, Presolve=0, Heuristics=0.0))

        @defVar(mod, 0 <= x <= 2, Int)
        @defVar(mod, 0 <= y <= 2, Int)
        @setObjective(mod, Max, x + 2y)
        @addConstraint(mod, y + x <= 3.5)
        function mycutgenerator(cb)
            x_val = getValue(x)
            y_val = getValue(y)
            TOL = 1e-6  
            # Check top right
            if y_val + x_val > 3 + TOL
                @addUserCut(cb, y + x <= 3)
            end
        end
        setcutcallback(mod, mycutgenerator)
        solve(mod)
        @test_approx_eq_eps getValue(x) 1.0 1e-6
        @test_approx_eq_eps getValue(y) 2.0 1e-6
    end
end

if Pkg.installed("CPLEXLink") != nothing
    using CPLEXLink

    let
        mod = Model(solver=CplexSolver())

        @defVar(mod, 0 <= x <= 2, Int)
        @defVar(mod, 0 <= y <= 2, Int)
        @setObjective(mod, Max, y + 0.5x)
        function corners(cb)
                x_val = getValue(x)
                y_val = getValue(y)
                TOL = 1e-6
                # Check top right
                if y_val + x_val > 3 + TOL
                        @addLazyConstraint(cb, y + x <= 3)
                end
            end
        setlazycallback(mod, corners)
        solve(mod)
        @test_approx_eq_eps getValue(x) 1.0 1e-6
        @test_approx_eq_eps getValue(y) 2.0 1e-6
    end
end

if Pkg.installed("GLPKMathProgInterface") != nothing
    using GLPKMathProgInterface

    let
        mod = Model(solver=GLPKSolverMIP())

        @defVar(mod, 0 <= x <= 2, Int)
        @defVar(mod, 0 <= y <= 2, Int)
        @setObjective(mod, Max, y + 0.5x)
        function corners(cb)
                x_val = getValue(x)
                y_val = getValue(y)
                TOL = 1e-6
                # Check top right
                if y_val + x_val > 3 + TOL
                        @addLazyConstraint(cb, y + x <= 3)
                end
            end
        setlazycallback(mod, corners)
        solve(mod)
        @test_approx_eq_eps getValue(x) 1.0 1e-6
        @test_approx_eq_eps getValue(y) 2.0 1e-6
    end
end
