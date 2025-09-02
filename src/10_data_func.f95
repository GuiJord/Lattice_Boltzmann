module data_mod
    use geometry_mod
    use parameters
    implicit none
    integer*8         :: test
    character(len=6)  :: test_str
    character(len=20) :: test_dir
    character(len=50) :: paraview_dir
    character(len=50) :: file_conv
    character(len=50) :: file_tortuosity
    character(len=50) :: file_points
    
contains
    
    !Data Collection ==============================================
    subroutine data_collection()
        call convergence_data
        call tortuosity_data
        if ( mod(time_step,tplot) == 0 ) then
            call paraview_data
        end if
    end subroutine data_collection

    subroutine convergence_data()
        open(10,file=file_conv, status="old", position="append")
        write(10,'(I0,A,1F10.4,A,1F10.4,A,1F10.4,A,1F10.4)')&
        &time_step,' ',log10(error_rho),' ',log10(error_u),' ',log10(error_ux),' ',log10(error_uy)
        close(10)
    end subroutine convergence_data

    subroutine tortuosity_data()
        open(10,file=file_tortuosity, status="old", position="append")
        write(10,'(I0,A,1G10.3,A,1G10.3)')&
        &time_step,' ',tortuosity,' ',error_tortuosity
        close(10)
    end subroutine tortuosity_data
    !======================================== Data Collection - End
    
    
    !File Management ==============================================
    subroutine create_files()
        read(*,'(I6)') test
        write(test_str,'(I6)') test
        test_str = adjustl(test_str)
        test_dir = './testset/test_'//test_str
        paraview_dir = trim(test_dir)//'/paraview'
        file_conv =  trim(test_dir)//'/convergence.dat'
        file_tortuosity =  trim(test_dir)//'/tortuosity.dat'
        ! file_points = trim(test_dir)//'/points.dat'

        open(10,file=file_conv,status='replace')
        close(10)
        open(10,file=file_tortuosity,status='replace')
        close(10)
        ! open(10,file=file_points,status='replace')
        ! close(10)
    end subroutine create_files
    !======================================== File Management - End
    
    
    !Paraview ==============================================
    subroutine paraview_data()
        character(len=50) :: file_paraview
        integer*8 :: x,y

        write(file_paraview,'(A,A,I0,A)') trim(paraview_dir),'/paraview_',time_step,'.dat'
        file_paraview=trim(file_paraview)

        open(20,file=file_paraview,status="replace")
        write(20,'(I0,A,I0)') nx,' ',ny
        do x = 1,nx
            do y = 1,ny
                !sem concentração
                ! write(20, '(1G10.5,A,1G10.3,A,1G10.4,A,1G10.3)') &
                !    rho(x,y),' ', u(x,y),' ', ux(x,y),' ', uy(x,y)
                !com concentração
                ! write(20, '(1G10.5,A,1G10.3,A,1G10.4,A,1G10.3,A,1G10.5)') &
                ! rho(x,y),' ', u(x,y),' ', ux(x,y),' ', uy(x,y),' ', C(x,y)
                !com ambos
                write(20, '(1G10.5,A,1G10.3,A,1G10.4,A,1G10.3,A,1G10.5,A,1G10.5)') &
                rho(x,y),' ', u(x,y),' ', ux(x,y),' ', uy(x,y),' ', C(x,y),' ',T(x,y)
                !com condutividade
                ! write(20, '(1G10.5,A,1G10.3,A,1G10.4,A,1G10.3,A,1G10.5,A,1G10.5,A,1G10.5)') &
                ! rho(x,y),' ', u(x,y),' ', ux(x,y),' ', uy(x,y),' ', C(x,y),' ',T(x,y),' ',cs2*(1/inv_tau_h_matrix(x,y)-0.5)
            end do
        end do
        close(20)
    end subroutine paraview_data
    !======================================== Paraview - End
    
    
    !Measure adsorption ==============================================
    subroutine adsorption_measurements_data()
    integer :: i,x,y
    real*8  :: C_total, C_adsorbed, C_free
    C_adsorbed = 0
    do i = 1,n_ads_points
        x = mask_ads_x(i)
        y = mask_ads_y(i)
        C_adsorbed = C_adsorbed + C(x,y)
    end do
    C_free = 0
    do i = 1,n_ads_points_frontier
        x = mask_ads_frontier_x(i)
        y = mask_ads_frontier_y(i)
        C_free = C_free + C(x,y)
    end do
    do i = 1,n_fluid_points
        x = fluid_mask_x(i)
        y = fluid_mask_y(i)
        C_free = C_free + C(x,y)
    end do

    C_total = sum(C)

    open(10,file='conservation.dat', status="old", position="append")
    write(10,'(I0,A,1F10.4,A,1F10.4,A,1F10.4)') time_step,' ', C_total,' ',C_adsorbed,' ',C_free
    close(10)

    open(10,file='adsorption.dat', status="old", position="append")
    write(10,'(I0,A,1F10.4,A,1F10.4)') time_step,' ', C(nx/2,1),' ',C(nx/2,2)
    close(10)
    end subroutine adsorption_measurements_data
    !======================================== Measure adsorption - End
    

    subroutine points()
    integer*8 :: x,y
    open(10,file=file_points)
    do x = 1,nx
        do y = 1,ny
            write(10,'(I0,A,I0)') x,' ',y
        end do
    end do
    close(10)
    end subroutine points
end module data_mod