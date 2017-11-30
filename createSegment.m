function seg = createSegment(origin, destination, wpts)
  
  seg=struct('A',[0,0],'B',[0,0]);
  s=size(wpts);
  i=1;
  found=0;
  while(found~=2 && i<=s(2))
      if size(origin) == size(wpts(i).id)
            if(origin==wpts(i).id)
                seg.A=wpts(i).pos;
                found=found+1;
          end
      end
      if size(destination) == size(wpts(i).id)
            if(destination==wpts(i).id)
                seg.B=wpts(i).pos;
                found=found+1;
            end
      end
  i=i+1;
  end

end

