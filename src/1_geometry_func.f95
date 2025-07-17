module geometry_mod
    implicit none
    !================================== Lattice Geometry - Beginning ============================================
    logical,   parameter    :: log_load_geometry=.FALSE.!.TRUE.!
    logical,   parameter    :: log_ads=.TRUE.
    
    integer*8               :: nx                       !number of nodes in x
    integer*8               :: ny                       !number of nodes in y
    integer*8               :: lx
    integer*8               :: ly
    
    integer*8, allocatable  :: lattice_mask(:,:)        !mask of 0 for fluid, 1 for solid, 2 for adsorption (porous), 3 frontier

    integer                 :: n_solid_points                   !number of solid points
    integer, allocatable    :: mask_x(:), mask_y(:)             !list of solid points coordinates

    integer*8               :: n_fluid_points                   !number of fluid points
    integer, allocatable    :: fluid_mask_x(:), fluid_mask_y(:) !list of fluid points coordinates
    
    integer                 :: n_ads_points                     !number of adsorption points
    integer, allocatable    :: mask_ads_x(:), mask_ads_y(:)     !list of adsorption points coordinates

    integer                 :: n_ads_points_frontier                            !number of frontier points
    integer, allocatable    :: mask_ads_frontier_x(:), mask_ads_frontier_y(:)   !list of frontier points coordinates
    integer, allocatable    :: num_neighb_ads_list(:)                           !list of number of adsorption neighbors for each frontier point
    !================================== Lattice Geometry - End ==================================================
    
contains

!Load or Create Geometry
subroutine geometry()
    if ( log_load_geometry ) then 
        call load_geometry
        call read_solid_coordinates
        call read_frontier_coordinates
        call read_adsorption_coordinates
        call read_fluid_coordinates
    else
        nx = 100
        ny = 100
        allocate(lattice_mask(nx,ny))
        lattice_mask = 0
        
        n_solid_points = 0
        n_ads_points = 0
        n_ads_points_frontier = 0
        call read_fluid_coordinates

    end if
    lx = nx - 1
    ly = ny - 1
end subroutine geometry

!Read solid coordinates
subroutine read_solid_coordinates()
    integer :: i
    open(unit=20, file="geometry_solid_xy.dat", status="old", action="read")
    ! Read number of coordinates
    read(20, *) n_solid_points
    allocate(mask_x(n_solid_points), mask_y(n_solid_points))
    ! Read each x-y pair
    do i = 1, n_solid_points
        read(20, *) mask_x(i), mask_y(i)
    end do
    close(20)
end subroutine read_solid_coordinates

!Read adsorption coordinates
subroutine read_adsorption_coordinates()
    integer :: i
    open(unit=20, file="geometry_ads_xy.dat", status="old", action="read")
    ! Read number of coordinates
    read(20, *) n_ads_points
    allocate(mask_ads_x(n_ads_points), mask_ads_y(n_ads_points))
    ! Read each x-y pair
    do i = 1, n_ads_points
        read(20, *) mask_ads_x(i), mask_ads_y(i)
    end do
    close(20)
end subroutine read_adsorption_coordinates

!Read frontier coordinates
subroutine read_frontier_coordinates()
    integer :: i
    open(unit=20, file="geometry_ads_frontier_xy.dat", status="old", action="read")
    ! Read number of coordinates
    read(20, *) n_ads_points_frontier
    allocate(mask_ads_frontier_x(n_ads_points_frontier), mask_ads_frontier_y(n_ads_points_frontier))
    allocate(num_neighb_ads_list(n_ads_points_frontier))
    ! Read each x-y pair
    do i = 1, n_ads_points_frontier
        read(20, *) mask_ads_frontier_x(i), mask_ads_frontier_y(i), num_neighb_ads_list(i)
    end do
    close(20)
end subroutine read_frontier_coordinates

!Read fluid coordinates
subroutine read_fluid_coordinates()
    integer*8 :: i,x,y
    n_fluid_points = nx*ny - n_solid_points - n_ads_points - n_ads_points_frontier
    allocate(fluid_mask_x(n_fluid_points),fluid_mask_y(n_fluid_points))

    i = 1
    do x = 1,nx
        do y = 1,ny
            if (lattice_mask(x,y) == 0) then
                fluid_mask_x(i) = x
                fluid_mask_y(i) = y
                i = i + 1
            end if
        end do
    end do
end subroutine read_fluid_coordinates

!Load Geometry
subroutine load_geometry()
    integer*8 :: x,y,ios
    open(10,file='geometry.dat', status='old', action='read', iostat=ios)
    read(10,*) nx, ny
    if (ios /= 0) then
      print *, "Error: Cannot open file ", trim('geometry.dat')
      stop
    end if
    allocate(lattice_mask(nx,ny))
    do x = 1, nx
      read(10, *, iostat=ios) (lattice_mask(x, y), y = 1, ny)
      if (ios /= 0) then
        print *, "Error: Failed to read data from file."
        stop
      end if
    end do
    close(10)
end subroutine load_geometry

end module geometry_mod