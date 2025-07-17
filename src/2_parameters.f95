module parameters
    use geometry_mod
    implicit none

    
    !LBM - Basic Parameters ==============================================
    integer*8, parameter :: D = 2           !number of dimensions
    integer*8, parameter :: Q = 9           !number of discretized velocities
    real*8,    parameter :: dx = 1.d0       !lenght of the spatial step
    real*8,    parameter :: dt = 1.d0       !length of the time step
    !======================================== LBM - Basic Parameters - End
    
    
    !Timesteps and Ploting ==============================================
    integer*8            :: time_step
    integer*8, parameter :: tmax = 7000  !max number of time steps
    integer*8, parameter :: number_plot = 100
    integer*8, parameter :: tplot = tmax/number_plot
    !======================================== Timesteps and Ploting - End
    
    
    !von Kàrmàn Tests ==============================================
    real*8 :: tortuosity
    real*8 :: tortuosity_old
    real*8 :: error_tortuosity
    !======================================== von Kàrmàn Tests - End
    

    !Initial Conditions ==============================================
    real*8,    parameter :: rho_0 = 1.d0                !initial density
    real*8,    parameter :: ux_0 = 0.d0, uy_0 = 0.d0    !initial velocity
    real*8,    parameter :: C_0 = 10.d0                 !initial concentration
    real*8,    parameter :: C_L = 1.d0                  !initial concentration left
    real*8,    parameter :: C_R = 1.d0                  !initial concentration right
    real*8,    parameter :: T_0 = 1.d0                  !initial temperature
    real*8,    parameter :: C_0_ads = 0.d0             !initial concentration in adsorption region
    real*8,    parameter :: T_0_ads = 0.d0            !initial temperature in adsorption region
    real*8,    parameter :: T_0_solid = 0.01d0          !initial temperature in solid region
    !======================================== Initial Conditions - End

    
    !================================== Collision - Beginning ============================================
    
    integer*8, parameter :: col_cmd = 1                     !operator command (BGK:1, TRT:2, MRT:3)

    !BGK ==============================================
    !f
    real*8,    parameter :: tau_f = 0.9d0                               !relaxation time of f
    real*8               :: inv_tau_f = 1.d0/tau_f                      !inverse of tau_f    
    !g
    real*8,    parameter :: tau_g = 0.9d0                               !relaxation time of g
    real*8               :: inv_tau_g = 1.d0/tau_g                      !inverse of tau_g
    !h
    real*8,    parameter :: tau_h = 0.9d0                               !relaxation time of h
    real*8               :: inv_tau_h = 1.d0/tau_h                      !inverse of tau_h
    !======================================== BGK - End
    

    !TRT ==============================================
    real*8,    parameter :: lmbd    = 0.25d0                            !lambda stability parameter
    !f
    real*8,    parameter :: omg_p_f = 0.9d0                             !omega+ relaxation time of f
    real*8,    parameter :: omg_m_f = 1/(lmbd/(1/(omg_p_f-0.5))+0.5)    !omega- relaxation time of f
    !g
    real*8,    parameter :: omg_p_g = 0.9d0                             !omega+ relaxation time of g
    real*8,    parameter :: omg_m_g = 1/(lmbd/(1/(omg_p_g-0.5))+0.5)    !omega- relaxation time of g
    !h
    real*8,    parameter :: omg_p_h = 0.9d0                             !omega+ relaxation time of h
    real*8,    parameter :: omg_m_h = 1/(lmbd/(1/(omg_p_h-0.5))+0.5)    !omega- relaxation time of h
    !======================================== TRT - End
    
    !MRT ==============================================
    real*8,    parameter :: omg_e_f  = 1.1d0                            !omega e relaxation time of f
    real*8,    parameter :: omg_ep_f = 1.2d0                            !omega epsilon relaxation time of f
    real*8,    parameter :: omg_q_f  = (16*tau_f-8)/(8*tau_f-1)         !omega q relaxation time of f
    real*8,    parameter :: omg_nu_f = 1/tau_f                          !omega nu relaxation time of f
    !MRT - Matrices
    real*8               :: M_G(9,9)
    real*8               :: M_inv_G(9,9)
    real*8               :: S_G(9,9)
    real*8               :: M_inv_S(9,9)
    real*8               :: M_inv_S_M(9,9)
    !======================================== MRT - End
    
    !================================== Collision - End ==================================================
    
    
    !================================== Probability Distribution Functions - Beginning ============================================
    
    !Main Matrices ==============================================
    real*8, allocatable  :: f(:,:,:)           !momentum dist func
    real*8, allocatable  :: feq(:,:,:)         !equilibrium dist func of f
    real*8, allocatable  :: f_t(:,:,:)         !collided dist func of f

    real*8, allocatable  :: g(:,:,:)           !concentration dist func
    real*8, allocatable  :: geq(:,:,:)         !equilibrium dist func of g
    real*8, allocatable  :: g_t(:,:,:)         !collided dist func of g

    real*8, allocatable  :: h(:,:,:)           !temperature dist func
    real*8, allocatable  :: heq(:,:,:)         !equilibrium dist func of h
    real*8, allocatable  :: h_t(:,:,:)         !collided dist func of h
    !======================================== Main Matrices - End
    
    
    !Moments ==============================================
    !f
    real*8, allocatable  :: rho(:,:)           !density matrix
    real*8, allocatable  :: rho_old(:,:)
    
    real*8, allocatable  :: ux(:,:)            !velocity x matrix
    real*8, allocatable  :: ux_old(:,:)        !old velocity x matrix
    
    real*8, allocatable  :: uy(:,:)            !velocity y matrix
    real*8, allocatable  :: uy_old(:,:)        !old velocity y matrix

    real*8, allocatable  :: u(:,:)             !velocity matrix
    real*8, allocatable  :: u_old(:,:)         !old velocity matrix

    !g
    real*8, allocatable  :: C(:,:)             !concentration matrix
    real*8, allocatable  :: C_old(:,:)         !old concentration matrix

    real*8, allocatable  :: C_a(:,:)           !adsorbed concentration matrix
    real*8, allocatable  :: C_a_old(:,:)       !old adsorbed concentration matrix
    
    !h
    real*8, allocatable  :: T(:,:)             !temperature matrix
    real*8, allocatable  :: T_old(:,:)         !old temperature matrix
    !======================================== Moments - End
    
    real*8, allocatable  :: w_E(:,:,:)         !auxiliary matrix 
    
    !================================== Probability Distribution Functions - End ==================================================

       
    
    !Weights ==============================================
    real*8,    parameter :: w0   = 4.d0/9.d0    !weight 0th direction
    real*8,    parameter :: w1_4 = 1.d0/9.d0    !weight 1-4 directions
    real*8,    parameter :: w5_8 = 1.d0/36.d0   !weight 5-8 directions
    real*8,    parameter :: w(Q) = [w1_4,w1_4,w1_4,w1_4,w5_8,w5_8,w5_8,w5_8,w0]         !weights array
    !======================================== Weights - End
    
    !Directions ==============================================
    real*8,    parameter :: ex(Q) = [1.d0,0.d0,-1.d0,0.d0,1.d0,-1.d0,-1.d0,1.d0,0.d0]   !x directions
    real*8,    parameter :: ey(Q) = [0.d0,1.d0,0.d0,-1.d0,1.d0,1.d0,-1.d0,-1.d0,0.d0]   !y directions
    
    integer*8, parameter :: op_directions(9) = [3,4,1,2,7,8,5,6,0]        !list of oposite directions
    !======================================== Directions - End
    
    !Sound velocity ==============================================
    real*8,    parameter :: cs2 = 1.d0/3.d0*dx*dx/(dt*dt)   !sound velocity squared
    real*8               :: cs = sqrt(cs2)                  !sound velocity
    real*8               :: inv_cs2 = 1.d0/cs2
    real*8               :: inv_2cs4 = 1/(2*cs2*cs2)
    real*8               :: inv_cs4 = 1.d0/cs2/cs2
    !======================================== Sound velocity - End
    
    
    
    !================================== Boundary Conditions - Beginning ============================================

    integer*8, parameter :: bc_cmd_f = 1    !(BB:1, IN_OUT:2)
    integer*8, parameter :: bc_cmd_g = 1    !(BB:1, IN_OUT:2)
    integer*8, parameter :: bc_cmd_h = 1    !(BB:1, IN_OUT:2)

    
    !Zou-He (NEBB) ==============================================
    real*8,    parameter :: ux_left = 0.1d0, uy_left = 0.d0         !velocity at LEFT Wall
    real*8,    parameter :: ux_right = 0.d0, uy_right = 0.d0        !velocity at RIGHT Wall
    real*8,    parameter :: ux_bottom = 0.d0, uy_bottom = 0.d0      !velocity at BOTTOM Wall
    real*8,    parameter :: ux_top = 0.d0, uy_top = 0.d0            !velocity at TOP Wall

    real*8,    parameter :: rho_left = 1.d0                         !density at LEFT Wall
    real*8,    parameter :: rho_right = 1.d0                        !density at RIGHT Wall
    real*8,    parameter :: rho_bottom = 0.d0                       !density at BOTTOM Wall
    real*8,    parameter :: rho_top = 0.d0                          !density at TOP Wall

    real*8,    parameter :: cst1  = 2.d0/3.d0
    real*8,    parameter :: cst2  = 1.d0/6.d0
    real*8,    parameter :: cst3  = 0.5d0
    !======================================== Zou-He (NEBB) - End

    !================================== Boundary Conditions - End ==================================================

    
    
    !================================== Convergence - Beginning ============================================

    real,     parameter :: tol = 1.e-8
    !Errors ==============================================
    real*8 :: error_rho, error_ux, error_uy, error_u  !density, velocity x, y and total errors
    real*8 :: error_C                                 !concentration error
    real*8 :: error_T                                 !temperature error
    !======================================== Errors - End

    !================================== Convergence - End ==================================================
    
    
    !Physical Properties ==============================================
    real*8               :: nu  !kinematic viscosity
    real*8               :: dif !mass diffusivity
    real*8               :: alp !heat diffusivity
    !======================================== Physical Properties - End

    
    !Adimensional Numbers ==============================================
    real*8               :: Re
    real*8               :: Ma
    real*8               :: Pr
    !======================================== Adimensional Numbers - End
    

    
    !================================== Adsorption - Beginning ============================================
    
    !Adsorption Constants ==============================================
    real*8,    parameter :: k_A = 0.01
    real*8,    parameter :: k_D = 0.001
    real*8               :: k_H = k_A/k_D
    !======================================== Adsorption Constants - End

    !Relaxation times for adsorption region ==============================================
    !g
    real*8,    parameter :: tau_g_ads = 0.9d0               !relaxation time of g
    real*8               :: inv_tau_g_ads = 1.d0/tau_g_ads  !inverse of tau_g
    real*8, allocatable  :: inv_tau_g_matrix(:,:)
    !h
    real*8,    parameter :: tau_h_ads = 0.9d0               !relaxation time of h in BGK
    real*8               :: inv_tau_h_ads = 1.d0/tau_h_ads  !inverse of tau_h
    real*8, allocatable  :: inv_tau_h_matrix(:,:)
    !======================================== Relaxation times for adsorption region - End
    
    !================================== Adsorption - End ==================================================
    
    
    
    !================================== Thermalization - Beginning ============================================
    
    real*8,    parameter :: zeta = 1.5d0
    ! real*8,    parameter :: theta = 1.d0                    !heat transfer coefficient 
    real*8,    parameter :: cp    = 1.d0
    ! real*8               :: zeta  = theta*dt/(dx*rho_0*cp)
    real*8,    parameter :: T_wall   = 1.d0
    real*8,    parameter :: T_top = 1.5d0
    real*8,    parameter :: T_bottom = 0.5d0
    
    !================================== Thermalization - End ==================================================
    


    !================================== Functions - Beginning ============================================
    contains
    
    subroutine allocation()
        allocate(f(nx,ny,Q),feq(nx,ny,Q),f_t(nx,ny,Q))
        allocate(rho(nx,ny),rho_old(nx,ny))
        allocate(u(nx,ny),u_old(nx,ny))
        allocate(ux(nx,ny),ux_old(nx,ny))
        allocate(uy(nx,ny),uy_old(nx,ny))

        allocate(g(nx,ny,Q),geq(nx,ny,Q),g_t(nx,ny,Q))
        allocate(C(nx,ny),C_old(nx,ny))
        allocate(C_a(nx,ny),C_a_old(nx,ny))

        allocate(h(nx,ny,Q),heq(nx,ny,Q),h_t(nx,ny,Q))
        allocate(T(nx,ny),T_old(nx,ny))
    end subroutine allocation

    subroutine physical_prop()
        if ( col_cmd == 1 ) then
            !BGK
            nu  = cs2*(tau_f-dt*0.5d0)
            dif = cs2*(tau_g-dt*0.5d0)
            alp = cs2*(tau_h-dt*0.5d0)
        else if ( col_cmd == 2 ) then
            !TRT
            nu  = cs2*(1/(omg_p_f*dt)-0.5d0)
            dif = cs2*(1/(omg_p_g*dt)-0.5d0)
            alp = cs2*(1/(omg_p_h*dt)-0.5d0)
        end if
        Re = ux_left*ny/nu
        Ma = ux_left/cs
        Pr = nu/alp
    end subroutine physical_prop

    subroutine set_MRT()
        real*8 :: v1,v2,v3,v4,v5,v6
        real*8 :: temp_row(9),temp_col(9)
        M_G(1,:) = [1.d0,1.d0,1.d0,1.d0,1.d0,1.d0,1.d0,1.d0,1.d0]
        M_G(2,:) = [-4.d0,-1.d0,-1.d0,-1.d0,-1.d0,2.d0,2.d0,2.d0,2.d0]
        M_G(3,:) = [4.d0,-2.d0,-2.d0,-2.d0,-2.d0,1.d0,1.d0,1.d0,1.d0]
        M_G(4,:) = [0.d0,1.d0,0.d0,-1.d0,0.d0,1.d0,-1.d0,-1.d0,1.d0]
        M_G(5,:) = [0.d0,-2.d0,0.d0,2.d0,0.d0,1.d0,-1.d0,-1.d0,1.d0]
        M_G(6,:) = [0.d0,0.d0,1.d0,0.d0,-1.d0,1.d0,1.d0,-1.d0,-1.d0]
        M_G(7,:) = [0.d0,0.d0,-2.d0,0.d0,2.d0,1.d0,1.d0,-1.d0,-1.d0]
        M_G(8,:) = [0.d0,1.d0,-1.d0,1.d0,-1.d0,0.d0,0.d0,0.d0,0.d0]
        M_G(9,:) = [0.d0,0.d0,0.d0,0.d0,0.d0,1.d0,-1.d0,1.d0,-1.d0]

        v1 = 1.d0/9.d0
        v2 = 0.25d0
        v3 = 1.d0/6.d0
        v4 = 1.d0/12.d0
        v5 = 1.d0/18.d0
        v6 = 1.d0/36.d0

        M_inv_G(1,:) = [v1,-v1,v1,0.d0,0.d0,0.d0,0.d0,0.d0,0.d0]
        M_inv_G(2,:) = [v1,-v6,-v5,v3,-v3,0.d0,0.d0,v2,0.d0]
        M_inv_G(3,:) = [v1,-v6,-v5,0.d0,0.d0,v3,-v3,-v2,0.d0]
        M_inv_G(4,:) = [v1,-v6,-v5,-v3,v3,0.d0,0.d0,v2,0.d0]
        M_inv_G(5,:) = [v1,-v6,-v5,0.d0,0.d0,-v3,v3,-v2,0.d0]
        M_inv_G(6,:) = [v1,v5,v6,v3,v4,v3,v4,0.d0,v2]
        M_inv_G(7,:) = [v1,v5,v6,-v3,-v4,v3,v4,0.d0,-v2]
        M_inv_G(8,:) = [v1,v5,v6,-v3,-v4,-v3,-v4,0.d0,v2]
        M_inv_G(9,:) = [v1,v5,v6,v3,v4,-v3,-v4,0.d0,-v2]

        S_G = 0.d0
        
        S_G(1,1) = 0.d0
        S_G(2,2) = omg_e_f
        S_G(3,3) = omg_ep_f
        S_G(4,4) = 0.d0
        S_G(5,5) = omg_q_f
        S_G(6,6) = 0.d0
        S_G(7,7) = omg_q_f
        S_G(8,8) = omg_nu_f
        S_G(9,9) = omg_nu_f

        M_inv_S   = matmul(M_inv_G,S_G)
        M_inv_S_M = matmul(M_inv_S,M_G)

        temp_row = M_inv_S_M(1,:)

        M_inv_S_M(1:8,:) = M_inv_S_M(2:9,:)

        M_inv_S_M(9,:) = temp_row

        temp_col = M_inv_S_M(:,1)

        M_inv_S_M(:,1:8) = M_inv_S_M(:,2:9)

        M_inv_S_M(:,9) = temp_col
    end subroutine set_MRT    
    !================================== Functions - End ==================================================
    
end module parameters

