/*
 * UniTime 3.5 (University Timetabling Application)
 * Copyright (C) 2013, UniTime LLC, and individual contributors
 * as indicated by the @authors tag.
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License along
 * with this program.  If not, see <http://www.gnu.org/licenses/>.
 * 
*/
package org.unitime.timetable.solver.jgroups;

import java.lang.reflect.Method;

import net.sf.cpsolver.ifs.util.DataProperties;

import org.jgroups.Address;
import org.jgroups.blocks.RpcDispatcher;

public interface RemoteSolverContainer<T> extends SolverContainer<T> {
	public boolean createRemoteSolver(String user, DataProperties config, Address caller);
	
	public RpcDispatcher getDispatcher();
	
	public Object dispatch(Address address, String user, Method method, Object[] args) throws Exception;
	
	public Object invoke(String method, String user, Class[] types, Object[] args) throws Exception;
	
	public T createProxy(Address address, String user);
}